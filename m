From: <Yanqing_Liu@Dell.com>
Subject: Issue of RDAC array failback
Date: Wed, 26 May 2010 10:08:23 -0500
Message-ID: <F757EE5C3631ED4DBDFD7709119219FE03BBEF81EA@AUSX7MCPS302.AMER.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
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
List-Id: dm-devel.ids

In testing with RHEL 5.4 on Dell PV MD series controller, we ran into the following issue:

The array uses RDAC device handler. When connections to one of the controller is, failover happens as normal. When connections are restored, LUNs are supposed to failback as expected, however it didn't happen every time. What we've found is, after failover, the multipath topology for the LUN is shown as the following, the failed path is not removed from multipathing structure:

...
mpath78 (360026b90006185270000132a4be80261) dm-21 ,
[size=4.0G][features=2 pg_init_retries 50][hwhandler=1 rdac][rw]
\_ round-robin 0 [prio=0][active]
 \_ #:#:#:#   -    #:#     [failed][faulty] <-- [ stale path, no sd node associated, however not removed from path topology]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:2:45  sdax 67:16   [active][ready]
...

After path is restored, seems multipath daemon is trying to remove the stale path and adding the restored path, however it hang at the step of reloading map. The related message is shown below:

,,,

sder: ownership set to mpath78  <--- [This is the restored path]
sder: not found in pathvec
sder: mask = 0xc
sder: state = 4
sder: prio = 100
: ownership set to mpath78  <-- [ stale path with no dev node associated]
: not found in pathvec
: mask = 0xc
: path checker = readsector0 (config file default)
: state = 1
: checker msg is "readsector0 checker reports path is down"
mpath78: removing path 135:80 with no devname    <--- [trying to remove the stale path]
mpath78: pgfailback = -2 (controller setting)
mpath78: pgpolicy = group_by_prio (controller setting)
mpath78: selector = round-robin 0 (internal default)
mpath78: features = 2 pg_init_retries 50 (controller setting)
mpath78: hwhandler = 1 rdac (controller setting)
mpath78: rr_weight = 1 (internal default)
mpath78: minio = 100 (controller setting)
mpath78: no_path_retry = 30 (controller setting)
pg_timeout = NONE (internal default)
mpath78: set ACT_RELOAD (path group topology change) <--- [Hangs here, never completed]


It seems like a possible deadlock condition which prevents multipath aggregation from completing. Any suggestion in here? The package in RHEL 5.4 is device-mapper-multipath-0.4.7.-30.

Thanks,
Yanqing
