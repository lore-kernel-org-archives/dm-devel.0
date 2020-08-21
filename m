From: lixiaokeng <lixiaokeng@huawei.com>
Subject: Re: [PATCH 2/5] libmultipath fix NULL dereference in
	select_action
Date: Fri, 21 Aug 2020 12:41:27 +0800
Message-ID: <547908f2-e1f4-be87-fabf-e361511d13b5@huawei.com>
References: <5ef5f58e-3a27-8959-3abb-4b4c401cc309@huawei.com>
	<285a42f1-69c2-ce2e-e30c-d12fb6edc859@huawei.com>
	<854ae1d12f9db76db005c317aaa213aadee07952.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <854ae1d12f9db76db005c317aaa213aadee07952.camel@suse.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: linfeilong@huawei.com, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids

Hi Martin:
   Thanks for your reply.

On 2020/8/19 0:28, Martin Wilck wrote:
> On Tue, 2020-08-18 at 21:06 +0800, lixiaokeng wrote:
>>
>> There are many NULL pointers in cmpp such as selector, features,
>> hwhandler and so on.
>> Here these on mpp is not NULL  but we can not be sure that won't be
>> in mpp, so we
>> add checking pointers of both mpp and cmpp before using them.
>>
>> The changes like "mpp->features != cmpp->features" make sure that
>> mpp->action is not
>> set to ACT_RELOAD when they both equal NULL. Other changes check
>> pointers don't equal
>> NULL. When only one is NULL, we think there is some difference
>> between mpp and cmpp,
>> so mpp->action should be set to ACT_RELOAD.
> 
> Hm. We should be able to make some assumptions about validity of
> structure fields.
> 
> I'd like to understand better what's going wrong here. cmpp is
> taken from curmp, which has been populated in get_dm_mpvec().
> get_dm_mpvec() calls disassemble_map(), which would always allocate
> mpp->features, AFAICS. Well, always, except if the parameter string was
> totally broken (or memory allocation failed):
>
   I add some printing in get_dm_mpvec, but I did not get any useful
information in messages. But we can see that there are path in mpp->pg.
The following are mpp and cmpp when coredump cause:

(gdb) p *mpp
$9 = {wwid = "36001405ef6a7bc355084b3abcb236a4c", '\000' <repeats 94 times>,
  alias_old = '\000' <repeats 127 times>, pgpolicy = 1,
  pgpolicyfn = 0x7f5fc886e0b0 <one_path_per_group>, nextpg = 0, bestpg = 1,
  queuedio = 0, action = 0, wait_for_udev = 0, uev_wait_tick = 0,
  pgfailback = -1, failback_tick = 0, rr_weight = 1, nr_active = 1,
  no_path_retry = 0, retry_tick = 0, disable_queueing = 0, minio = 1,
  flush_on_last_del = 1, attribute_flags = 0, fast_io_fail = 5,
  retain_hwhandler = 2, deferred_remove = 1, delay_watch_checks = -1,
  delay_wait_checks = -1, marginal_path_err_sample_time = -1,
  marginal_path_err_rate_threshold = -1,
  marginal_path_err_recheck_gap_time = -1,
  marginal_path_double_failed_time = -1, skip_kpartx = 1, max_sectors_kb = 0,
  force_readonly = 0, force_udev_reload = 0, needs_paths_uevent = 0,
  ghost_delay = -1, ghost_delay_tick = 0, dev_loss = 0, uid = 0, gid = 0,
  mode = 0, size = 2097152, paths = 0x0, pg = 0x55a07fafbb90, dmi = 0x0,
  alias = 0x55a07fade4d0 "mpatha", alias_prefix = 0x7f5fc8886b4a "mpath",
  selector = 0x55a07fade4b0 "service-time 0", features = 0x55a07fac24b0 "0",
  hwhandler = 0x55a07fade510 "1 alua", mpe = 0x0, hwe = 0x55a07faec5a0,
  waiter = 0, stat_switchgroup = 0, stat_path_failures = 0, stat_map_loads = 0,
  stat_total_queueing_time = 0, stat_queueing_timeouts = 0,
  stat_map_failures = 0, mpcontext = 0x0, prkey_source = 0, reservation_key = {
    _v = 0}, sa_flags = 0 '\000', prflag = 0 '\000', all_tg_pt = 0,
  generic_mp = {ops = 0x7f5fc8897a40 <dm_gen_multipath_ops>}}
(gdb) p *cmpp
$10 = {
  wwid = "36001405ef6a7bc355084b3abcb236a4c\000\063\066a4c", '\000' <repeats 88 times>,
  alias_old = '\000' <repeats 127 times>, pgpolicy = 0, pgpolicyfn = 0x0,
  nextpg = 0, bestpg = 1, queuedio = 0, action = 0, wait_for_udev = 0,
  uev_wait_tick = 0, pgfailback = 0, failback_tick = 0, rr_weight = 0,
  nr_active = 0, no_path_retry = 0, retry_tick = 0, disable_queueing = 0,
  minio = 0, flush_on_last_del = 0, attribute_flags = 0, fast_io_fail = 0,
  retain_hwhandler = 0, deferred_remove = 0, delay_watch_checks = 0,
  delay_wait_checks = 0, marginal_path_err_sample_time = 0,
  marginal_path_err_rate_threshold = 0, marginal_path_err_recheck_gap_time = 0,
  marginal_path_double_failed_time = 0, skip_kpartx = 0, max_sectors_kb = 0,
  force_readonly = 0, force_udev_reload = 0, needs_paths_uevent = 0,
  ghost_delay = 0, ghost_delay_tick = 0, dev_loss = 0, uid = 0, gid = 0,
  mode = 0, size = 2097152, paths = 0x0, pg = 0x0, dmi = 0x55a07fb0d5f0,
  alias = 0x55a07fafc490 "mpatha", alias_prefix = 0x0, selector = 0x0,
  features = 0x0, hwhandler = 0x0, mpe = 0x0, hwe = 0x0, waiter = 0,
  stat_switchgroup = 0, stat_path_failures = 0, stat_map_loads = 0,
  stat_total_queueing_time = 0, stat_queueing_timeouts = 0,
  stat_map_failures = 0, mpcontext = 0x0, prkey_source = 0, reservation_key = {
    _v = 0}, sa_flags = 0 '\000', prflag = 0 '\000', all_tg_pt = 0,
  generic_mp = {ops = 0x7f5fc8897a40 <dm_gen_multipath_ops>}}

> int disassemble_map()
> {
> ...
> 	p += get_word(p, &mpp->features);
> 
> 	if (!mpp->features)
> 		return 1;
> 
> The same holds for mpp->hwhandler, mpp->selector, and mpp->pg (not sure
> what you refer to with "and so on").
> 
> In this case the map also wouldn't have paths, and shouldn't have been
> added to curmp in the first place. So IMO this is caused by
> get_dm_mpvec() not checking the return value of disassemble_map().
> map_discovery() in multipathd does this better - maps for which
> update_multipath_table() fails are not added. Can you confirm that you
> see this crash only in multipath, not in multipathd?

  I have been runing 48h, this crash did not happen in mutlipathd. But I
can't confirm that just in multipath, not in multipathd.

Regards
Lixiaokeng
