From: Scott Bauer <scott.bauer@intel.com>
Subject: Re: [PATCH v5] dm: add unstriped target
Date: Tue, 19 Dec 2017 10:25:21 -0700
Message-ID: <20171219172521.urjbootg2kh7irib@sbauer-Z170X-UD5>
References: <cover.1513618685.git.heinzm@redhat.com>
	<1513639353-7231-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1513639353-7231-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Keith Busch <keith.busch@intel.com>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

> +#define DM_MSG_PREFIX "unstriped"
> +
> +void cleanup_unstripe(struct unstripe_c *uc, struct dm_target *ti)
> +{
> +	if (uc->dev)
> +		dm_put_device(ti, uc->dev);
> +	kfree(uc);
> +}
> +
> +/*
> + * Contruct an unstriped mapping.
> + * <number of stripes> <chunk size> <stripe #> <dev_path> <offset>
> + */
> +static int unstripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> +{

[snip]

> +	tmp_len = width;
> +	if (sector_div(tmp_len, uc->chunk_size)) {
> +		ti->error = "Target length not divisible by chunk size";
> +		goto err;
> +	}
> +
> +	r = dm_set_target_max_io_len(ti, uc->chunk_size);
> +	if (r) {
> +		ti->error = "Failed to set max io len";
> +		goto err;
> +	}
> +
> +	ti->private = uc;
> +	return 0;
> +err:
> +	cleanup_unstripe(uc, ti);
> +	return r;
> +}
[snip]
> +static int unstripe_iterate_devices(struct dm_target *ti,
> +				    iterate_devices_callout_fn fn, void *data)
> +{
> +	struct unstripe_c *uc = ti->private;
> +
> +	return fn(ti, uc->dev, uc->physical_start, ti->len, data);
> +}


I was testing some error conditions:

#1 set up legitimate unstripe.
#2 remove it.
#3 set up an unstripe that fails the

> +     tmp_len = width;
> +     if (sector_div(tmp_len, uc->chunk_size)) {
> +             ti->error = "Target length not divisible by chunk size";
> +             goto err;
> +     }

check in the constructor (so give it an odd length):

I'm greeted by this splat:


[   76.349033] BUG: unable to handle kernel NULL pointer dereference at 0000000066b57171
[   76.349051] IP: unstripe_iterate_devices+0x13/0x20 [dm_unstripe]
[   76.349055] PGD 0 P4D 0 
[   76.349062] Oops: 0000 [#1] SMP
[   76.349065] Modules linked in: dm_unstripe binfmt_misc nls_iso8859_1 snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec intel_rapl x86_pkg_temp_thermal snd_hda_core intel_powerclamp kvm_intel snd_hwdep snd_pcm kvm snd_seq_midi snd_seq_midi_event snd_rawmidi irqbypass crct10dif_pclmul snd_seq crc32_pclmul ghash_clmulni_intel pcbc snd_seq_device snd_timer aesni_intel snd mei_me aes_x86_64 crypto_simd glue_helper cryptd shpchp mei soundcore mac_hid tpm_crb acpi_pad coretemp parport_pc ppdev lp parport ip_tables x_tables autofs4 hid_generic usbhid hid i915 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm igb mxm_wmi e1000e dca ptp ahci pps_core i2c_algo_bit libahci video wmi
[   76.349153] CPU: 2 PID: 1688 Comm: dmsetup Not tainted 4.15.0-rc2+ #7
[   76.349157] Hardware name: Gigabyte Technology Co., Ltd. Z170X-UD5/Z170X-UD5-CF, BIOS F5 03/07/2016
[   76.349160] task: 00000000dfd78dfc task.stack: 00000000fadda433
[   76.349166] RIP: 0010:unstripe_iterate_devices+0x13/0x20 [dm_unstripe]
[   76.349169] RSP: 0018:ffffb89842d13c00 EFLAGS: 00010286
[   76.349173] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000001749c7ff
[   76.349176] RDX: ffffb89842d13c0c RSI: ffffffff902ad590 RDI: ffffb89841ed1040
[   76.349179] RBP: ffffffff902ad590 R08: ffffb89842d13c0c R09: ffffffff902ad590
[   76.349182] R10: ffffb89842d13c68 R11: ffffa020daef0000 R12: ffffa0208ec63600
[   76.349184] R13: 0000000000000001 R14: ffffffff902b29a0 R15: ffffb89842d13d20
[   76.349189] FS:  00007faa3ee63400(0000) GS:ffffa020f1c80000(0000) knlGS:0000000000000000
[   76.349192] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   76.349195] CR2: 0000000000000008 CR3: 000000045c342004 CR4: 00000000003606e0
[   76.349200] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   76.349203] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   76.349205] Call Trace:
[   76.349217]  dm_table_has_no_data_devices+0x91/0xc0
[   76.349225]  dm_swap_table+0x6b/0x2e0
[   76.349230]  ? table_load+0x350/0x350
[   76.349234]  ? __dm_suspend+0x7c/0x1d0
[   76.349239]  ? table_load+0x350/0x350
[   76.349243]  dev_suspend+0x95/0x220
[   76.349247]  ctl_ioctl+0x1bf/0x450
[   76.349257]  ? yield_to+0x130/0x1b0
[   76.349261]  dm_ctl_ioctl+0xa/0x10
[   76.349268]  do_vfs_ioctl+0x9f/0x5f0
[   76.349274]  ? SYSC_semctl+0xf9/0x130
[   76.349279]  ? _cond_resched+0x16/0x40
[   76.349285]  ? task_work_run+0x38/0xa0
[   76.349291]  SyS_ioctl+0x74/0x80
[   76.349296]  entry_SYSCALL_64_fastpath+0x1e/0x81
[   76.349301] RIP: 0033:0x7faa3e766587
[   76.349304] RSP: 002b:00007ffcba093b88 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   76.349309] RAX: ffffffffffffffda RBX: 000000000d4d1614 RCX: 00007faa3e766587
[   76.349312] RDX: 0000563b73da7190 RSI: 00000000c138fd06 RDI: 0000000000000003
[   76.349314] RBP: 0000000000000004 R08: 00007faa3ea72ba8 R09: 00007ffcba0939f0
[   76.349317] R10: 00007faa3ea720b3 R11: 0000000000000246 R12: 0000563b72eb1190
[   76.349320] R13: 00007ffcba093f14 R14: 00007ffcba093ebc R15: 0000000000018000
[   76.349324] Code: <48> 8b 50 08 48 8b 30 41 ff e1 0f 1f 00 0f 1f 44 00 00 48 8b 47 38 
[   76.349359] RIP: unstripe_iterate_devices+0x13/0x20 [dm_unstripe] RSP: ffffb89842d13c00
[   76.349362] CR2: 0000000000000008
[   76.349366] ---[ end trace f92285c94fd36893 ]---


Two questions:

Do we need to set ti-private = NULL in "cleanup_unstripe"? Also, do we
need to have :


static int unstripe_iterate_devices(struct dm_target *ti,
                                    iterate_devices_callout_fn fn, void *data)
{
        struct unstripe_c *uc = ti->private;

	if (uc)
           return fn(ti, uc->dev, uc->physical_start, ti->len, data);
}

~
