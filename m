From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [dm-devel] [PATCH v2] staging: writeboost: Add dm-writeboost
Date: Fri, 12 Dec 2014 12:41:21 +0100
Message-ID: <548AD461.1020707@acm.org>
References: <54883195.1060304@gmail.com> <20141211152626.GA8196@redhat.com> <548A39E7.80508@gmail.com> <548AB172.4000103@acm.org> <548AB6E4.2020302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <548AB6E4.2020302@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: snitzer@redhat.com, gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org, thornber@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Mark Ruijter <mruijter@gmail.com>
List-Id: dm-devel.ids

On 12/12/14 10:35, Akira Hayakawa wrote:
> Writeboost batches number of writes into a log (that is 512KB large) and submits to SSD
> which maximizes the throughput and the lifetime of the SSD.

Does this mean that dm-writeboost is similar to btier ? If so, this 
makes me wonder which of these two subsystems would be the best 
candidate for upstream inclusion. As far as I know btier doesn't split 
bio's. The source code of btier can be downloaded from 
http://sourceforge.net/projects/tier/.

Bart.
