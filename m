From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipathd: Add 'sysfs' prioritizer
Date: Fri, 3 Jun 2016 09:05:57 +0200
Message-ID: <57512C55.2010008@suse.de>
References: <1463998828-28133-1-git-send-email-hare@suse.de>
	<20160531223414.00004376@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160531223414.00004376@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids



On 05/31/2016 10:34 PM, Sebastian Herbszt wrote:
> Hannes Reinecke wrote:
>> Recent kernels have an 'access_state' attribute which allows
>> us to read the asymmetric access state directly from sysfs.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  libmultipath/discovery.c           | 33 +++++++++++++++++++++++++++++
>>  libmultipath/discovery.h           |  2 ++
>>  libmultipath/prio.h                |  1 +
>>  libmultipath/prioritizers/Makefile |  3 ++-
>>  libmultipath/prioritizers/sysfs.c  | 43 ++++++++++++++++++++++++++++++++++++++
>>  libmultipath/propsel.c             |  6 +++++-
>>  multipath/multipath.conf.5         | 14 ++++++++++++-
>>  7 files changed, 99 insertions(+), 3 deletions(-)
>>  create mode 100644 libmultipath/prioritizers/sysfs.c
> 
> How about just adding this to the alua prioritizer?
> This new feature could then depend on a "sysfs" argument.
> 
No. The 'sysfs' prioritizer is using the abstract kernel sysfs
interface, for which every device handler provides the information.
So in theory it's independent on the underlying device handler.

However, only the ALUA device handler has been reworked to provide
up-to-date information; for the other device handlers there is a
risk of the sysfs information is getting out-of-date.

Hence I've restricted the 'detect_prioritizer' algorithm to select
'sysfs' only if an ALUA system is present.
But this doesn't imply in any way that the 'sysfs' prioritizer can be
used only for ALUA systems.

Christophe, what about merging the patch?

Cheers,

Hannes
