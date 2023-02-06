/*
 * https://github.com/torvalds/linux/blob/master/crypto/fips.c
 * https://pointer-overloading.blogspot.com/2013/09/linux-creating-entry-in-proc-file.html
 */

#include <linux/module.h>
#include <linux/sysctl.h>

int fips_enabled = 1;

static struct ctl_table crypto_sysctl_table[] = {
	{
		.procname	= "fips_enabled",
		.data		= &fips_enabled,
		.maxlen		= sizeof(int),
		.mode		= 0444,
		.proc_handler	= proc_dointvec
	},
        {}
};
static struct ctl_table crypto_dir_table[] = {
	{
		.procname       = "crypto",
		.mode           = 0555,
		.child          = crypto_sysctl_table
	},
	{}
};

static struct ctl_table_header *crypto_sysctls;

static void crypto_proc_fips_init(void)
{
	crypto_sysctls = register_sysctl_table(crypto_dir_table);
}

static void crypto_proc_fips_exit(void)
{
	unregister_sysctl_table(crypto_sysctls);
}

static int __init fips_init(void)
{
	crypto_proc_fips_init();
	return 0;
}

static void __exit fips_exit(void)
{
	crypto_proc_fips_exit();
}

MODULE_LICENSE("GPL");
subsys_initcall(fips_init);
module_exit(fips_exit);
