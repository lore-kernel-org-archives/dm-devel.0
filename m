From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: How dm multipath handle IO
Date: Fri, 14 Mar 2014 18:12:05 +0900
Message-ID: <5322C7E5.8020000@gmail.com>
References: <CAO5znatnsF_x=-EOKHpezw0M4QNZ5KXiawEGKQ7hkXMCwfQy2Q@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAO5znatnsF_x=-EOKHpezw0M4QNZ5KXiawEGKQ7hkXMCwfQy2Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

Let's google it.
Is this the article you are looking for?
https://www.kernel.org/doc/ols/2007/ols2007v2-pages-235-244.pdf

--
Akira

On 3/14/14 5:44 PM, Nicolas Michel wrote:
> Hello Guys,
> 
> It's a general question about how dm and particularly multipathd handle IO? I mean, is it a transaction? Is each IO initiated from the OS get back an acknowledgement? If it is, is there a retry mechanism?
> Or are the IO sent blindingly to the block device?
> 
> If someone have some good article on it, I would be very interested in understanding more deeply how IO are handled.
> 
> Thanks a lot,
> 
> -- 
> Nicolas MICHEL
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
