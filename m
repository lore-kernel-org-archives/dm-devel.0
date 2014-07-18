From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH RFC 00/10] dm-dedup: device-mapper
	deduplication target
Date: Fri, 18 Jul 2014 10:44:23 -0400
Message-ID: <20140718144423.GB4762@redhat.com>
References: <535ed0d2.0729e00a.4489.0c48@mx.google.com>
	<20140505182450.GA16456@redhat.com>
	<20140506134357.GA27331@vass-desktop>
	<20140718024336.GA1291@redhat.com>
	<CAFTzLMNEuPHAp02CHwCfktyWcHdb-rYzSx4ekWHis8QQHvmxNw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAFTzLMNEuPHAp02CHwCfktyWcHdb-rYzSx4ekWHis8QQHvmxNw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vasily Tarasov <tarasov@vasily.name>
Cc: device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@infradead.org>, ejt@redhat.com, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Fri, Jul 18 2014 at  7:59am -0400,
Vasily Tarasov <tarasov@vasily.name> wrote:

> Hi Mike,
> 
> Thanks for your initial reviewing steps! Here is what we plan to do:
> 
> 1) Address your current comments

Thanks, try to look at how the other DM targets have tables with
arguments that have a fixed position (less flexible than name=value but
tools like lvm2 benefit from the rigidity).
 
> 2) Few people mentioned that our documentation need to be formatted
> better and be more detailed. We'll address this.

Yes, it could be more comprehensive.  And it would be nice if it were
updated to have the same kind of sections/flow that other targets'
Documentation/device-mapper/ files have (e.g. cache.txt and
thin-provisioning.txt).

But overall the plan sounds great.
