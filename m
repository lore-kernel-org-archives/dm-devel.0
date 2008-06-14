From: Luke S Crawford <lsc@prgmr.com>
Subject: Re: "Snapshots and mirrors may not yet be mixed."
Date: 14 Jun 2008 06:09:41 -0400
Message-ID: <m3mylojpju.fsf@luke.xen.prgmr.com>
References: <m3bq28lrte.fsf@luke.xen.prgmr.com>
	<Pine.LNX.4.64.0806112217580.23166@engineering.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0806112217580.23166@engineering.redhat.com>
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
Cc: chris@prgmr.com
List-Id: dm-devel.ids

Mikulas Patocka <mpatocka@redhat.com> writes:
> There is a bug that "lvconvert -s" can create snapshot of a mirror
> ... and to my surprise, once it was created this way, it worked.
> 
> So maybe we could remove this restriction at all. There was some
> concern that dmeventd may misbehave in this situation. lvm commands
> seem to handle snapshots of a mirror fine.


Yes, lvconvert seems to make proper snapshots from my (corelog) mirrors.
I've been playing with them for a few days now and no problems yet.  
