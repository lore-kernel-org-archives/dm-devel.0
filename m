From: Mike Snitzer <snitzer@redhat.com>
Subject: [LSF/MM TOPIC] update NVMe multipath to conditionally
 claim controllers
Date: Mon, 29 Jan 2018 16:17:23 -0500
Message-ID: <20180129211722.GB5744@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

I'd like to have the same Linux kernel be able to use either NVMe's
native multipath or DM multipath.

Should be relatively simple to filter which controllers can/cannot be
claimed by NVMe multipathing (without having to resort to the big hammer
of CONFIG_NVME_MULTIPATH).

I'd like to understand what is the preferred disposition of the filter
list (black or white)?  I assume having a blacklist would be more
inkeeping with Christoph's desire for NVMe to be the default for NVMe
multipathing.  But that disposition aside, not sure if there are other
issues that should influence implementing more flexible use of NVMe
resources.

Thanks,
Mike
