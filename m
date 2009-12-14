From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH libdmraid-events 0/3] Assorted fixes
Date: Mon, 14 Dec 2009 15:28:50 +0100
Message-ID: <1260800930.7677.35.camel@o>
References: <20091211032255.766079509@suse.de>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091211032255.766079509@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Neil,

you seem to be based on an old version of libdmraid-events.c.

Please rebase to sources.redhat.com:/cvs/dm/ (dmraid subdirectory is
recent), which most likely has all of that addressed already and rebase
if you still find the issues.

Thanks,
Heinz

On Fri, 2009-12-11 at 14:22 +1100, NeilBrown wrote:
> Hi,
>  a recent code inspection found a few minor bugs in libdmraid-events. 
>  Here are 3 patches which address these issues.
>  This is based on 1.0.0.rc4 retrieved from
> 
> http://sources.redhat.com/lvm2/wiki/DMRAID_Eventing?action=AttachFile&do=get&target=libdmraid-events_DSO-1.0.0.rc4.tgz
> 
> Thanks,
> NeilBrown
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
