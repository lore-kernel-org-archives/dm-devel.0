From: Christoph Hellwig <hch@lst.de>
Subject: Re: dm-mpath: Handling SCSI-3 PR RELEASE in
	multi-controller	environment
Date: Wed, 21 Sep 2016 19:14:40 +0200
Message-ID: <20160921171440.GB24882@lst.de>
References: <57E24F7E.4030103@huawei.com> <20160921150427.GB9748@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160921150427.GB9748@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: wangyibin@huawei.com, jiangyiwen <jiangyiwen@huawei.com>, dm-devel@redhat.com, hch@lst.de
List-Id: dm-devel.ids

On Wed, Sep 21, 2016 at 11:04:27AM -0400, Mike Snitzer wrote:
> Which kernel are you using?  Christoph (now cc'd) has introduced a new
> PR api.  I merged a fix from him relatively recently (commit 9c72bad1f3
> "dm: call PR reserve/unreserve on each underlying device")

The PR API will handle this fine, but mpathpersist isn't using it yet.
Switching mpathpersist to use the API if available would be a useful
improvement.
