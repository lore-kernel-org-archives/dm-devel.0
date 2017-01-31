From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2] dm-crypt: replace RCU read-side section
	with rwsem
Date: Tue, 31 Jan 2017 09:58:33 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1701310956300.18743@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1701310820140.18743@file01.intranet.prod.int.rdu2.redhat.com>
	<1485874031-22813-1-git-send-email-okozina@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1485874031-22813-1-git-send-email-okozina@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ondrej Kozina <okozina@redhat.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids


Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>


On Tue, 31 Jan 2017, Ondrej Kozina wrote:

> The lockdep splat bellow hints a bug in RCU usage in dm-crypt
> since kernel keyring fn user_key_payload() is in fact a wrapper
> for rcu_dereference_protected() which must not be called
> with only rcu_read_lock() section mark.
> 
> Unfortunately there's currently no correct function in
> kernel keyring subsystem we could call in while RCU read-side
> section is used. Let's drop RCU in favour of rwsem
> until proper function in kernel keyring is available.
> 
> ===============================
> [ INFO: suspicious RCU usage. ]
> 4.10.0-rc5 #2 Not tainted
> -------------------------------
> ./include/keys/user-type.h:53 suspicious rcu_dereference_protected() usage!
> other info that might help us debug this:
> rcu_scheduler_active = 2, debug_locks = 1
> 2 locks held by cryptsetup/6464:
>  #0:  (&md->type_lock){+.+.+.}, at: [<ffffffffa02472a2>] dm_lock_md_type+0x12/0x20 [dm_mod]
>  #1:  (rcu_read_lock){......}, at: [<ffffffffa02822f8>] crypt_set_key+0x1d8/0x4b0 [dm_crypt]
> stack backtrace:
> CPU: 1 PID: 6464 Comm: cryptsetup Not tainted 4.10.0-rc5 #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
> Call Trace:
>  dump_stack+0x67/0x92
>  lockdep_rcu_suspicious+0xc5/0x100
>  crypt_set_key+0x351/0x4b0 [dm_crypt]
>  ? crypt_set_key+0x1d8/0x4b0 [dm_crypt]
>  crypt_ctr+0x341/0xa53 [dm_crypt]
>  dm_table_add_target+0x147/0x330 [dm_mod]
>  table_load+0x111/0x350 [dm_mod]
>  ? retrieve_status+0x1c0/0x1c0 [dm_mod]
>  ctl_ioctl+0x1f5/0x510 [dm_mod]
>  dm_ctl_ioctl+0xe/0x20 [dm_mod]
>  do_vfs_ioctl+0x8e/0x690
>  ? ____fput+0x9/0x10
>  ? task_work_run+0x7e/0xa0
>  ? trace_hardirqs_on_caller+0x122/0x1b0
>  SyS_ioctl+0x3c/0x70
>  entry_SYSCALL_64_fastpath+0x18/0xad
> RIP: 0033:0x7f392c9a4ec7
> RSP: 002b:00007ffef6383378 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007ffef63830a0 RCX: 00007f392c9a4ec7
> RDX: 000000000124fcc0 RSI: 00000000c138fd09 RDI: 0000000000000005
> RBP: 00007ffef6383090 R08: 00000000ffffffff R09: 00000000012482b0
> R10: 2a28205d34383336 R11: 0000000000000246 R12: 00007f392d803a08
> R13: 00007ffef63831e0 R14: 0000000000000000 R15: 00007f392d803a0b
> 
> Reported-by: Milan Broz <mbroz@redhat.com>
> Fixes: c538f6ec9f56 (dm crypt: add ability to use keys from the kernel key retention service)
> Signed-off-by: Ondrej Kozina <okozina@redhat.com>
> ---
>  drivers/md/dm-crypt.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 7c6c572..8a9f742 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1534,18 +1534,18 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
>  		return PTR_ERR(key);
>  	}
>  
> -	rcu_read_lock();
> +	down_read(&key->sem);
>  
>  	ukp = user_key_payload(key);
>  	if (!ukp) {
> -		rcu_read_unlock();
> +		up_read(&key->sem);
>  		key_put(key);
>  		kzfree(new_key_string);
>  		return -EKEYREVOKED;
>  	}
>  
>  	if (cc->key_size != ukp->datalen) {
> -		rcu_read_unlock();
> +		up_read(&key->sem);
>  		key_put(key);
>  		kzfree(new_key_string);
>  		return -EINVAL;
> @@ -1553,7 +1553,7 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
>  
>  	memcpy(cc->key, ukp->data, cc->key_size);
>  
> -	rcu_read_unlock();
> +	up_read(&key->sem);
>  	key_put(key);
>  
>  	/* clear the flag since following operations may invalidate previously valid key */
> -- 
> 2.7.4
> 
