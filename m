From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [PATCH RFC 00/10] dm-dedup: device-mapper
 deduplication target
Date: Sat, 07 Mar 2015 08:31:28 +0900
Message-ID: <54FA38D0.8090002@gmail.com>
References: <535ed0d2.0729e00a.4489.0c48@mx.google.com>
	<20150306183722.GD15736@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150306183722.GD15736@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Vasily Tarasov <tarasov@vasily.name>
Cc: Christoph Hellwig <hch@infradead.org>, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>
List-Id: dm-devel.ids

Vasily,

I recommend you to add tests into dmts
https://github.com/jthornber/device-mapper-test-suite

This testing framework can eliminate such trivial bugs.
And the tests become available to other developers are
valuable too.
It's written in Ruby and Joe designed carefully. So it's
really easy to add tests.

- Akira

On 2015/03/07 3:37, Vivek Goyal wrote:
> On Mon, Apr 28, 2014 at 06:03:06PM -0400, Vasily Tarasov wrote:
>> This is a request for comments for Dmdedup.
> 
> mkfs.xfs crash the dm-dedup driver. mkfs.ext4 worked find though for me.
> 
> Thanks
> Vivek
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
