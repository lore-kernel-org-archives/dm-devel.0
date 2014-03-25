From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: best way to detect a dm device is dm-multipath
	from	userspace?
Date: Tue, 25 Mar 2014 22:54:58 +0000
Message-ID: <20140325225458.GD16068@agk-dp.fab.redhat.com>
References: <20140325172022.GA32702@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140325172022.GA32702@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

udev db as zkabelac says; or

sysfs .../dm/uuid; or

dm ioctl lookup by name or major:minor and get uuid (dmsetup info equivalent)

then check for mpath prefix on the uuid  
[Assuming it was created with the standard tools]

Alasdair
