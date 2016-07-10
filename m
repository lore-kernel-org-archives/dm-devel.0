From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 0/6] Delete attributes with default values
Date: Sun, 10 Jul 2016 17:54:07 +0200
Message-ID: <00515d37-239e-7142-1b26-3f999a4931cf@gmail.com>
References: <1468022328-5905-1-git-send-email-xose.vazquez@gmail.com>
	<CABr-GncP-rzeXogT1EFZTtFrre2UUSV6i-AJ27GZ3mTvcxx-7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GncP-rzeXogT1EFZTtFrre2UUSV6i-AJ27GZ3mTvcxx-7Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/09/2016 10:17 AM, Christophe Varoqui wrote:

> I'll wait for comments from distribution maintainers on this patchset.
> Because, though we have already deleted the checker_name settings when equal
> to the default value, it should be clear that with this patchset changing a
> default may cause re-certification for all impacted devices. This can be
> viewed as a problem for distributors.

In general terms arrays manufacturers only test, certify and write documentation
for enterprise distributions. They don't care about upstream kernel or
upstream multipath-tools.
And enterprise distributions usually carry very outdated and heavily patched
packages. The next enterprise distributions are, at least, two years away.


Let's see the patches:

>       multipath-tools: delete attributes with DEFAULT_* values in hwtable.c

This patch deletes:
     48                 .features      = DEFAULT_FEATURES,
     44                 .hwhandler     = DEFAULT_HWHANDLER,
     28                 .prio_name     = DEFAULT_PRIO,
      1                 .minio         = DEFAULT_MINIO,
      1                 .minio_rq      = DEFAULT_MINIO_RQ,

- DEFAULT_FEATURES	is "0"

  It has to be explicitly defined, no default value possible.

- DEFAULT_HWHANDLER	is "unset/0"

  Always it's Hardware-dependent, no default value possible.

- DEFAULT_PRIO		is "const"

  All others alternatives are Hardware-dependent or an unusual option(random/weightedpath/datacore/iet).

- DEFAULT_MINIO		is 1000

  Relevant for hardware? Is default value right?

- DEFAULT_MINIO_RQ	is 1

  Hardware-dependent related? Is default value right?


>       multipath-tools: delete prio_args attribute when it is equal to default value

This patch deletes:
     73                 .prio_args     = NULL,

- DEFAULT_PRIO_ARGS	is ""

  It has to be explicitly defined, no default value possible.


>       multipath-tools: delete no_path_retry attribute when it is equal to default value

This patch deletes:
     28                 .no_path_retry = NO_PATH_RETRY_UNDEF,

- DEFAULT_NO_PATH_RETRY	is 0/unset

  Perhaps this default value could be changed in the future. ???

The current hwtable is full with some "random" values:
     28                 .no_path_retry = NO_PATH_RETRY_UNDEF,
     15                 .no_path_retry = NO_PATH_RETRY_QUEUE,
      7                 .no_path_retry = 12,
      5                 .no_path_retry = 15,
      4                 .no_path_retry = (300 / DEFAULT_CHECKINT),
      4                 .no_path_retry = 300,
      4                 .no_path_retry = 18,
      2                 .no_path_retry = 30,
      2                 .no_path_retry = 10,
      1                 .no_path_retry = NO_PATH_RETRY_FAIL,
      1                 .no_path_retry = 6,
      1                 .no_path_retry = 5,

Is no_path_retry really Hardware-dependent? or were values selected arbitrarily?
Were they tested with upstream kernel/multipath-tools? Any logic here?


>       multipath-tools: delete minio_rq attribute when it is equal to default value

This patch deletes:
      1                 .minio_rq      = 1,

Duplicate, see above.


>       multipath-tools: delete fast_io_fail attribute when it is equal to default value

This patch deletes:
      2                 .fast_io_fail  = 5,

- DEFAULT_FAST_IO_FAIL	is	5

  Perhaps this default value could be changed in the future. ???

At hwtable there are only 3 defined:
      2                 .fast_io_fail  = 5,
      1                 .fast_io_fail  = 10,

Again, Hardware-dependent? or crystal ball? Is default value good enough?


>       multipath-tools: delete pgpolicy attribute when it is equal to default value

This patch deletes:
      1                 .pgpolicy      = FAILOVER,

- DEFAULT_PGPOLICY is	FAILOVER

At hwtable:
     48                 .pgpolicy      = GROUP_BY_PRIO,
     23                 .pgpolicy      = MULTIBUS,
      5                 .pgpolicy      = GROUP_BY_SERIAL,
      1                 .pgpolicy      = FAILOVER,

FAILOVER(DEFAULT_PGPOLICY) is not very popular. Maybe it should be changed to
GROUP_BY_PRIO and then remove 48 lines.


Right now there is not a well defined policy. What should be the default rule?

(a) a *mininal* "devices section": only hardware-dependent, stability or
    high-performance related attributes are allowed.
(b) a *fully detailed* "devices section", all attributes defined.
(c) *no rules* at "devices section", do what you want.

Now it's (c), should it be changed?
