From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [dm-devel] [PATCH v2] staging: writeboost: Add dm-writeboost
Date: Fri, 12 Dec 2014 10:12:18 +0100
Message-ID: <548AB172.4000103@acm.org>
References: <54883195.1060304@gmail.com> <20141211152626.GA8196@redhat.com> <548A39E7.80508@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <548A39E7.80508@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: snitzer@redhat.com, gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org, thornber@redhat.com, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 12/12/14 01:42, Akira Hayakawa wrote:
> 1. Writeboost shouldn't split the bio into 4KB chunks.
> No. It is necessary.
> I know WALB (https://github.com/starpos/walb) logs data without
> splitting but the data structure becomes complicated.
> If you read my code carefully, you will notice that splitting
> helps the design simplicity and performance.

This is the first time I see someone claiming that reducing the request 
size improves performance. I don't know any SSD model for which 
splitting requests improves performance.

Additionally, since bio's are split by dm-writeboost, this makes me 
wonder how atomic writes will ever be supported ? Atomic writes are 
being standardized by the T10 SCSI committee. I don't think the Linux 
block layer already supports atomic writes today but I expect support 
for atomic writes to be added to the block layer sooner or later. See 
e.g. http://www.t10.org/doc13.htm / SBC-4 SPC-5 Atomic writes and reads 
for the latest draft specification.

Bart.
