From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 12/14] libmultipathpersist: use
 update_multipath_table/status, in get_mpvec
Date: Mon, 07 Sep 2020 16:33:15 +0200
Message-ID: <1249b66af15efd82f3e37835d74f18a1c5398a73.camel@suse.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<5beca982-98a1-e48b-f86f-95810bc3c49c@huawei.com>
	<20200905000501.GH11108@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200905000501.GH11108@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, lixiaokeng <lixiaokeng@huawei.com>
Cc: dm-devel, list <dm-devel@redhat.com>, linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Fri, 2020-09-04 at 19:05 -0500, Benjamin Marzinski wrote:
> On Wed, Sep 02, 2020 at 03:24:33PM +0800, lixiaokeng wrote:
> > The return values of dm_get_map, disassemble_map in get_mpvec
> > were not checked. Use update_multipath_table/status to instead
> > of them.
> > 
> 
> Looks mostly good. I agree that we should be checking the results of
> getting the raw data before we try to disassemble it. But, there's
> not
> really any point to calling continue as the last operation of a loop.
> Perhaps
> 
> if (update_multipath_table(mpp, pathvec, DI_CHECKER) == DMP_OK)
> 	update_multipath_status(mpp);
> 
> makes more sense.

I was thinking about this before, and wondered whether we should call
remove_map() here if we encounter an error. Looking at it again and
comparing with get_dm_mpvec(), I think we should.

Regards
Martin
