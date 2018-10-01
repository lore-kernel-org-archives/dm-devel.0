From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH v3 02/19] libmultipath: fix tur checker
 double locking
Date: Mon, 01 Oct 2018 22:44:06 +0200
Message-ID: <8d1b4d256211d4ee6222bdc24563b09695bc883a.camel@suse.de>
References: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
	<1537571127-10143-3-git-send-email-bmarzins@redhat.com>
	<3bad257069d68444b0b2743d4b38ba6b6d15501d.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3bad257069d68444b0b2743d4b38ba6b6d15501d.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Bart Van Assche <bart.vanassche@wdc.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 2018-10-01 at 22:09 +0200, Martin Wilck wrote:
> 
> I like the lock removal a lot, but not so much the conversion into a
> string. Why not keep the dev_t? 
> 
> Or maybe even easier, the other way around: why don't we make it a
> char* and simply set checker->dev_t = &pp->dev_t?

OK, that 2nd one won't work because pp may be destroyed before the
checker terminates. Got it. Still I'd prefer keeping a dev_t in the
checker structure rather than a char[32].

Martin
