From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: DMF_FREEING flag checking
Date: Mon, 10 Mar 2008 12:18:00 +0000
Message-ID: <20080310121800.GB1788@agk.fab.redhat.com>
References: <746615.15795.qm@web31715.mail.mud.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <746615.15795.qm@web31715.mail.mud.yahoo.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mai N <thumai9999@yahoo.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Mar 09, 2008 at 09:23:09PM -0700, Mai N wrote:
> I think we need to check, in __get_uuid_cell() , DMF_FREEING flag, to
> cover the race condition that we are trying to get the device while
> others is freeing (or have freed) it, same check is needed in
> __get_name_cell()...

I don't ever recall any bug reports that could be ascribed to this.
But I agree that it's not immediately obvious the code is correct.

So we need to find code paths that would cause a race, or write a
test program to demonstrate it.

> static struct hash_cell *__get_uuid_cell(const char *str)
> {
>         + struct mapped_device *md = NULL; 
> 
>         list_for_each_entry (hc, _uuid_buckets + h,  uuid_list)
>                 + md = hc->md;  
>                 + if ((!strcmp(hc->uuid, str)) &&
>                 +   (md)  && (!(test_bit(DMF_FREEING, &md->flags)))) {
> 
>                 - if (!strcmp(hc->uuid, str)) {
>                         dm_get(hc->md);
> }

The fix would be need to be within dm.c to ensure dm_get() can't succeed
while the final dm_put() is underway.  The question is, are there any
*actual* code paths which could lead to that happening, where existing
locking/serialisation is inadequate?
 
Alasdair
-- 
agk@redhat.com
