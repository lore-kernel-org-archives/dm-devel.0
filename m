From: michal virgovic <michalvirgovic1@gmail.com>
Subject: [BUG] Oops caused by FEC in 4.10.0
Date: Wed, 15 Mar 2017 21:22:02 +0100
Message-ID: <CAMKhuNG_AKfY_EB9C_Y-8q7sR+9u+Mn9w-hb1YvZQBCNLC_-ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=f403045fb4ec8f2544054acab203
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: samitolvanen@google.com, agk@redhat.com, snitzer@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

--f403045fb4ec8f2544054acab203
Content-Type: text/plain; charset=UTF-8

Hi,
This oops keeps appearing.

Attachment file is the reproducer. Fec,hash devices, salt and root
digest are not correct, if required i can send a script, where
everything is computed properly.

Output of crash:
Message from syslogd@debian8 at Mar 15 20:08:54 ...
 kernel:[  731.046277] BUG: stack guard page was hit at
ffffc90001233ff8 (stack is ffffc90001234000..ffffc90001237fff)


[  731.046277] BUG: stack guard page was hit at ffffc90001233ff8
(stack is ffffc90001234000..ffffc90001237fff)
[  731.046284] kernel stack overflow (double-fault): 0000 [#1] SMP
[  731.046285] Modules linked in: sha256_ssse3 sha256_generic
dm_verity dm_bufio reed_solomon dm_mod loop nls_utf8 isofs udf
crc_itu_t binfmt_misc cfg80211 rfkill nfsd auth_rpcgss oid_registry
nfs_acl nfs lockd grace fscache sunrpc joydev crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel pcbc snd_intel8x0 aesni_intel
snd_ac97_codec aes_x86_64 crypto_simd snd_pcm glue_helper cryptd
i2c_piix4 acpi_cpufreq i2c_core video snd_timer evdev ac97_bus snd
serio_raw soundcore button tpm_tis tpm_tis_core pcspkr battery ac tpm
fuse parport_pc ppdev lp parport autofs4 ext4 crc16 jbd2 mbcache sg
sr_mod cdrom sd_mod ata_generic hid_generic usbhid hid ohci_pci
ehci_pci ahci ohci_hcd ata_piix libahci ehci_hcd crc32c_intel usbcore
psmouse libata usb_common scsi_mod e1000
[  731.046329] CPU: 2 PID: 123 Comm: kworker/u8:2 Not tainted 4.10.0 #1
[  731.046330] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
VirtualBox 12/01/2006
[  731.046340] Workqueue: kverityd verity_work [dm_verity]
[  731.046341] task: ffff88012fda0180 task.stack: ffffc90001234000
[  731.046345] RIP: 0010:__flush_write_list+0x18/0x80 [dm_bufio]
[  731.046346] RSP: 0018:ffffc90001234000 EFLAGS: 00010286
[  731.046347] RAX: ffff88012fda0180 RBX: ffffc90001234058 RCX: 0000000000000000
[  731.046348] RDX: ffff88012fda0180 RSI: ffff880152557820 RDI: ffffc90001234000
[  731.046349] RBP: ffffc90001234040 R08: ffffc90001234058 R09: ffffc90001234148
[  731.046349] R10: 000000000000a000 R11: 0000000000000000 R12: ffff880152557800
[  731.046350] R13: ffffc900012340b0 R14: 0000000000000001 R15: ffff88015228d0c0
[  731.046352] FS:  0000000000000000(0000) GS:ffff880159d00000(0000)
knlGS:0000000000000000
[  731.046352] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  731.046353] CR2: ffffc90001233ff8 CR3: 000000012ec61000 CR4: 00000000000406e0
[  731.046359] Call Trace:
[  731.046365]  ? __bufio_new+0x8e/0x2e0 [dm_bufio]
[  731.046366]  ? new_read+0x5a/0xe0 [dm_bufio]
[  731.046368]  ? verity_verify_level+0x72/0x180 [dm_verity]
[  731.046369]  ? verity_hash_for_block+0x3c/0xe0 [dm_verity]
[  731.046370]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046380]  ? __kernel_fpu_end+0x20/0xa0
[  731.046381]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046383]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046384]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046386]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046387]  ? __kernel_fpu_end+0x20/0xa0
[  731.046388]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046390]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046391]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046392]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046394]  ? __kernel_fpu_end+0x20/0xa0
[  731.046395]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046396]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046398]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046399]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046400]  ? __kernel_fpu_end+0x20/0xa0
[  731.046402]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046403]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046404]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046406]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046407]  ? __kernel_fpu_end+0x20/0xa0
[  731.046408]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046410]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046411]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046412]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046414]  ? __kernel_fpu_end+0x20/0xa0
[  731.046415]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046417]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046418]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046419]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046421]  ? __kernel_fpu_end+0x20/0xa0
[  731.046422]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046423]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046425]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046426]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046427]  ? __kernel_fpu_end+0x20/0xa0
[  731.046429]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046430]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046431]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046432]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046434]  ? __kernel_fpu_end+0x20/0xa0
[  731.046435]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046437]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046438]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046439]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046441]  ? __kernel_fpu_end+0x20/0xa0
[  731.046442]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046443]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046445]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046454]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046456]  ? __kernel_fpu_end+0x20/0xa0
[  731.046457]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046459]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046460]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046461]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046463]  ? __kernel_fpu_end+0x20/0xa0
[  731.046464]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046465]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046467]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046468]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046469]  ? __kernel_fpu_end+0x20/0xa0
[  731.046471]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046472]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046474]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046475]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046476]  ? __kernel_fpu_end+0x20/0xa0
[  731.046478]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046479]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046480]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046482]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046483]  ? __kernel_fpu_end+0x20/0xa0
[  731.046484]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046486]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046487]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046488]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046490]  ? __kernel_fpu_end+0x20/0xa0
[  731.046491]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046492]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046494]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046495]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046497]  ? __kernel_fpu_end+0x20/0xa0
[  731.046498]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046499]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046501]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046502]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046503]  ? __kernel_fpu_end+0x20/0xa0
[  731.046505]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046506]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046507]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046509]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046510]  ? __kernel_fpu_end+0x20/0xa0
[  731.046511]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046513]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046514]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046515]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046517]  ? __kernel_fpu_end+0x20/0xa0
[  731.046518]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046520]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046521]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046522]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046524]  ? __kernel_fpu_end+0x20/0xa0
[  731.046525]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046526]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046528]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046529]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046530]  ? __kernel_fpu_end+0x20/0xa0
[  731.046532]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046533]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046534]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046536]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046537]  ? __kernel_fpu_end+0x20/0xa0
[  731.046538]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046540]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046541]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046542]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046544]  ? __kernel_fpu_end+0x20/0xa0
[  731.046545]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046547]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046548]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046549]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046551]  ? __kernel_fpu_end+0x20/0xa0
[  731.046552]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046553]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046555]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046556]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046559]  ? set_next_entity+0x70/0x9e0
[  731.046560]  ? __kernel_fpu_end+0x20/0xa0
[  731.046561]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046563]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046564]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046565]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046567]  ? __kernel_fpu_end+0x20/0xa0
[  731.046568]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046569]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046571]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046572]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046585]  ? __blk_run_queue+0x2f/0x40
[  731.046586]  ? __kernel_fpu_end+0x20/0xa0
[  731.046588]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046589]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046591]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046592]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046593]  ? __kernel_fpu_end+0x20/0xa0
[  731.046595]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046596]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046597]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046599]  ? fec_decode_rsb+0x6a9/0x9c0 [dm_verity]
[  731.046600]  ? __kernel_fpu_end+0x20/0xa0
[  731.046601]  ? verity_fec_decode+0x8e/0x160 [dm_verity]
[  731.046603]  ? verity_verify_level+0x151/0x180 [dm_verity]
[  731.046604]  ? verity_hash_for_block+0xa8/0xe0 [dm_verity]
[  731.046605]  ? verity_work+0x5e/0x189 [dm_verity]
[  731.046609]  ? process_one_work+0x14d/0x410
[  731.046611]  ? worker_thread+0x62/0x490
[  731.046612]  ? rescuer_thread+0x320/0x320
[  731.046614]  ? kthread+0x104/0x140
[  731.046615]  ? kthread_park+0x80/0x80
[  731.046621]  ? ret_from_fork+0x26/0x40
[  731.046621] Code: 41 5d 41 5e 41 5f e9 78 f0 d4 e0 0f 0b 66 0f 1f
44 00 00 0f 1f 44 00 00 55 48 89 e5 53 48 89 fb 48 83 e4 f0 48 83 ec
30 48 89 e7 <e8> 93 a1 d4 e0 48 8b 03 48 39 c3 74 4c 48 8b 03 48 be 00
01 00
[  731.046638] RIP: __flush_write_list+0x18/0x80 [dm_bufio] RSP:
ffffc90001234000
[  731.046639] ---[ end trace 55a62936c3c55e6b ]---

--f403045fb4ec8f2544054acab203
Content-Type: application/octet-stream; name=fec_crash
Content-Disposition: attachment; filename=fec_crash
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j0be4xsa0

IyEvYmluL2Jhc2ggLXgKCiMgZmFpbHMgb24ga2VybmVsIDQuMTAuMAoKREVWX05BTUU9dGVzdF9k
ZXZpY2UKREVWX0RBVEE9dGVzdF9kYXRhCkRFVl9EQVRBX0w9L2Rldi9sb29wMApERVZfSEFTSD1o
YXNoX2RldgpERVZfSEFTSF9MPS9kZXYvbG9vcDEKREVWX0ZFQz1mZWNfZGV2CkRFVl9GRUNfTD0v
ZGV2L2xvb3AyCgojIHByZXBhcmUgZGV2aWNlcwpkZCBpZj0vZGV2L3plcm8gb2Y9JERFVl9EQVRB
IGJzPTQwOTYgY291bnQ9MTAKZGQgaWY9L2Rldi96ZXJvIG9mPSRERVZfSEFTSCBicz00MDk2IGNv
dW50PTEwCmRkIGlmPS9kZXYvemVybyBvZj0kREVWX0ZFQyAgYnM9NDA5NiBjb3VudD01MAoKbG9z
ZXR1cCAkREVWX0RBVEFfTCAkREVWX0RBVEEKbG9zZXR1cCAkREVWX0hBU0hfTCAkREVWX0hBU0gK
bG9zZXR1cCAkREVWX0ZFQ19MICRERVZfRkVDCgojIGNyZWF0ZSBkZXZpY2Ugd2l0aCBkbXNldHVw
IHdpdGggc3BlY2lmaWVkIHRhYmxlCmRtc2V0dXAgLXIgY3JlYXRlICRERVZfTkFNRSAtLXRhYmxl
ICIwIDgwIHZlcml0eSAxICRERVZfREFUQV9MICRERVZfSEFTSF9MIDQwOTYgNDA5NiAxMCAwIHNo
YTI1NiA4OTA5NDFmYjU0ZjQ5ZDllYzU5ODcyZDI3OWZhYTVmZjkzZjFmOWRlZDY2NjMyMDAwZGVj
MThmM2Y0NDRiN2VjIGFlYTMyMzQzMTQ0ZjAyY2Y2ZTQ0YTUwMzQzMzg2ZWFiMjUwODQ4NDEyZTNl
Y2UxODgwMzk0ODE0YWM0YWFhNTQgOCB1c2VfZmVjX2Zyb21fZGV2aWNlICRERVZfRkVDX0wgZmVj
X3Jvb3RzIDEwIGZlY19ibG9ja3MgMjAgZmVjX3N0YXJ0IDAiCgp1ZGV2YWRtIHNldHRsZQoKZG1z
ZXR1cCB0YWJsZSAkREVWX05BTUUKZG1zZXR1cCBscwoKIyBjbGVhbgpkbXNldHVwIHJlbW92ZSAk
REVWX05BTUUKbG9zZXR1cCAtZCAkREVWX0RBVEFfTApsb3NldHVwIC1kICRERVZfSEFTSF9MCmxv
c2V0dXAgLWQgJERFVl9GRUNfTApybSAkREVWX0hBU0ggJERFVl9GRUMgJERFVl9EQVRBCg==
--f403045fb4ec8f2544054acab203
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--f403045fb4ec8f2544054acab203--
