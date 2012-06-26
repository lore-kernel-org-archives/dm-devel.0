From: Brian Bunker <brian@purestorage.com>
Subject: Re: why doesn't multipathd use the device?
Date: Tue, 26 Jun 2012 14:24:58 -0700
Message-ID: <09C26239-B41A-4080-A719-12A8A57C8975@purestorage.com>
References: <A01D98BC-7342-4771-B139-F0A5F757D431@purestorage.com>
	<1340343876.27156.8.camel@lapoo.opensvc.com>
	<994E3EEC-8A44-4C18-9A2D-45B01F09FCFC@purestorage.com>
	<1340392131.26608.1.camel@lapoo.opensvc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1340392131.26608.1.camel@lapoo.opensvc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

OK, I have the output of 'multipath -v3' and the output of 'dmsetup table'. I don't see the smoking gun though.

multipath -v3
Jun 26 13:46:40 | Found matching wwid [3624a937056ea3c50504e404700010009] in bindings file. Setting alias to mpathbkp
Jun 26 13:46:40 | sdq: ownership set to mpathbkp
Jun 26 13:46:40 | sdq: not found in pathvec
Jun 26 13:46:40 | sdq: mask = 0xc
Jun 26 13:46:40 | sdq: get_state
Jun 26 13:46:40 | sdq: state = running
Jun 26 13:46:40 | sdq: state = 3
Jun 26 13:46:40 | sdq: state = running
Jun 26 13:46:40 | sdq: const prio = 1
Jun 26 13:46:40 | sdac: ownership set to mpathbkp
Jun 26 13:46:40 | sdac: not found in pathvec
Jun 26 13:46:40 | sdac: mask = 0xc
Jun 26 13:46:40 | sdac: get_state
Jun 26 13:46:40 | sdac: state = running
Jun 26 13:46:40 | sdac: state = 3
Jun 26 13:46:40 | sdac: state = running
Jun 26 13:46:40 | sdac: const prio = 1
Jun 26 13:46:40 | sdal: ownership set to mpathbkp
Jun 26 13:46:40 | sdal: not found in pathvec
Jun 26 13:46:40 | sdal: mask = 0xc
Jun 26 13:46:40 | sdal: get_state
Jun 26 13:46:40 | sdal: state = running
Jun 26 13:46:40 | sdal: state = 3
Jun 26 13:46:40 | sdal: state = running
Jun 26 13:46:40 | sdal: const prio = 1
Jun 26 13:46:40 | sdau: ownership set to mpathbkp
Jun 26 13:46:40 | sdau: not found in pathvec
Jun 26 13:46:40 | sdau: mask = 0xc
Jun 26 13:46:40 | sdau: get_state
Jun 26 13:46:40 | sdau: state = running
Jun 26 13:46:40 | sdau: state = 3
Jun 26 13:46:40 | sdau: state = running
Jun 26 13:46:40 | sdau: const prio = 1
Jun 26 13:46:40 | mpathbkp: pgfailover = -1 (internal default)
Jun 26 13:46:40 | mpathbkp: pgpolicy = multibus (config file default)
Jun 26 13:46:40 | mpathbkp: selector = round-robin 0 (internal default)
Jun 26 13:46:40 | mpathbkp: features = 0 (internal default)
Jun 26 13:46:40 | mpathbkp: hwhandler = 0 (internal default)
Jun 26 13:46:40 | mpathbkp: rr_weight = 1 (internal default)
Jun 26 13:46:40 | mpathbkp: minio = 1 rq (config file default)
Jun 26 13:46:40 | mpathbkp: no_path_retry = NONE (internal default)
Jun 26 13:46:40 | pg_timeout = NONE (internal default)
Jun 26 13:46:40 | mpathbkp: set ACT_RELOAD (path group topology change)
reload: mpathbkp (3624a937056ea3c50504e404700010009) undef PURE,FlashArray
size=500G features='0' hwhandler='0' wp=undef
`-+- policy='round-robin 0' prio=1 status=undef
  |- 1:0:1:10 sdq  65:0   active ready running
  |- 1:0:0:10 sdac 65:192 active ready running
  |- 0:0:1:10 sdal 66:80  undef ready running
  `- 0:0:0:10 sdau 66:224 undef ready running

dmsetup table:
mpathbkg: 0 1048576000 multipath 0 0 1 1 round-robin 0 4 1 8:48 1 8:96 1 65:80 1 8:144 1 
mpathbkf: 0 1048576000 multipath 0 0 1 1 round-robin 0 4 1 8:16 1 8:64 1 65:48 1 8:112 1 
mpathbkq: 0 1048576000 multipath 0 0 1 1 round-robin 0 4 1 65:32 1 65:224 1 66:112 1 67:0 1 
mpathbkp: 0 1048576000 multipath 0 0 1 1 round-robin 0 4 1 65:0 1 65:192 1 66:80 1 66:224 1 
mpathbko: 0 1048576000 multipath 0 0 1 1 round-robin 0 4 1 8:240 1 65:176 1 66:64 1 66:208 1 
mpathbkn: 0 1048576000 multipath 0 0 1 1 round-robin 0 4 1 65:96 1 8:160 1 65:240 1 66:128 1 
mpathbkm: 0 1048576000 multipath 0 0 1 1 round-robin 0 4 1 65:16 1 65:208 1 66:96 1 66:240 1 
mpathbkl: 0 1048576000 multipath 0 0 1 1 round-robin 0 4 1 8:208 1 65:144 1 66:32 1 66:176 1 
mpathbkk: 0 1048576000 multipath 0 0 1 1 round-robin 0 4 1 65:112 1 8:176 1 66:0 1 66:144 1 
mpathbkj: 0 1048576000 multipath 0 0 1 1 round-robin 0 4 1 65:128 1 8:192 1 66:160 1 66:16 1 
mpathbki: 0 1048576000 multipath 0 0 1 1 round-robin 0 4 1 8:224 1 65:160 1 66:48 1 66:192 1 
mpathbkh: 0 1048576000 multipath 0 0 1 1 round-robin 0 4 1 8:32 1 8:80 1 8:128 1 65:64 1 

Thanks,
Brian

On Jun 22, 2012, at 12:08 PM, Christophe Varoqui wrote:

> On ven., 2012-06-22 at 10:00 -0700, Brian Bunker wrote:
>> We are currently using multibus as a path_grouping_policy since all of our ports are active and there is no need to weight any different than others. The array is active / active.
>> 
>> In poking around the multipath source files I am assuming that this is what is happening in domap since that is the only path that returns a negative number to the caller in main.c in multipathd:
>> 
>> 		if (lock_multipath(mpp, 1)) {
>> 			condlog(3, "%s: failed to create map (in use)",
>> 				mpp->alias);
>> 			return DOMAP_RETRY;
>> 		}
>> 
>> I guess that it didn't log since the log level of multipath was lower and that is why you want me to run at '-v 3'? If it is true that it believes that the map is in use what does that mean?
>> 
> 
> Usual suspects are other device maps layered on these paths or
> filesystems. 'dmsetup table' will help confirm the former, df the later.
> 
> Regards,
> cvaroqui
> 
> 

Brian Bunker
brian@purestorage.com
