From: Christoph Hellwig <hch@lst.de>
Subject: Re: dm-mpath: Handling SCSI-3 PR RELEASE in
	multi-controller	environment
Date: Fri, 14 Oct 2016 15:48:25 +0200
Message-ID: <20161014134825.GA21707@lst.de>
References: <1CD7AA44E04E6942954526708D37BF7B287F89@szxeml509-mbs.china.huawei.com>
	<20161009151622.GA19856@lst.de> <57FF5194.4030402@huawei.com>
	<57FF6CFD.3060708@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <57FF6CFD.3060708@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Yibin Wang <wangyibin@huawei.com>
Cc: Jiangyiwen <jiangyiwen@huawei.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hi Yibin,

On Thu, Oct 13, 2016 at 07:16:13PM +0800, Yibin Wang wrote:
> BTW, did you mean using dm_pr::fail_early as the indication whether
> multipath_iterate_devices() should fail early upon failure? If that's the 
> case,
> I can't see it is used anywhere except in dm_pr_register().
>
> Please correct me if I am wrong.  Thanks!

Yes, fail_early was intended to ensure we don't break out of the
loop.  But it's obviously not checked in the current code, so we'll need
to fix it indeed.  If you have existing patches for that please send
them out, else I'm going to look into it.
