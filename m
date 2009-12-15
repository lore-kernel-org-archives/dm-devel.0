From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH libdmraid-events 0/3] Assorted fixes
Date: Tue, 15 Dec 2009 12:07:32 +1100
Message-ID: <20091215120732.1ffb55b8@notabene.brown>
References: <20091211032255.766079509@suse.de>
	<1260800930.7677.35.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1260800930.7677.35.camel@o>
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
Cc: heinzm@redhat.com
List-Id: dm-devel.ids

On Mon, 14 Dec 2009 15:28:50 +0100
Heinz Mauelshagen <heinzm@redhat.com> wrote:

> Neil,
> 
> you seem to be based on an old version of libdmraid-events.c.
> 
> Please rebase to sources.redhat.com:/cvs/dm/ (dmraid subdirectory is
> recent), which most likely has all of that addressed already and rebase
> if you still find the issues.
> 
>

Also, I tried building from that source tree and there seem to be a number
of problems.
 - include/dmraid/dmreg.h is needed but not provided
 - lib/dmraid.a needs lib/device/partition.o, but there is no rule for
   building that file.
 - when tools/dmraid is build, the "-I" flags don't get passed to 'cc' so the
   compile fails ... I haven't managed to figure out why that is yet.

Thanks,
NeilBrown
