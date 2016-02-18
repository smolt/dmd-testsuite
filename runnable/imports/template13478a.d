module imports.template13478a;

version (D_InlineAsm_X86)
    version = TestInlineAsm;
else version (D_InlineAsm_X86_64)
    version = TestInlineAsm;
else
{
   version = LDC_InlineAsm;
   import ldc.llvmasm;
}

bool foo(T)() {
    // Make sure this is not inlined so template13478.o actually
    // needs to reference it.
    version (TestInlineAsm)
        asm { nop; }
    else version (LDC_InlineAsm)
    {
        // Just __asm isn't enough to break inlining
        pragma(LDC_never_inline); __asm("", "");
        // note: LDC, even for ARM, can just use asm {}, as long
        // as no instructions are given.  And it won't be inlined
    } 
    else
        static assert(0, "Unsupported platform");
    return false;
}
