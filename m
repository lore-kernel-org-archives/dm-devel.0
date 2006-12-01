From: "Ming Zhao" <mingzhao99th@gmail.com>
Subject: Re: [RFC][PATCH] dm-cache: block level disk cache target
	for device mapper
Date: Thu, 30 Nov 2006 23:49:10 -0500
Message-ID: <b1e142760611302049p64ca787bpcc0a0e48605cd145@mail.gmail.com>
References: <200611271826.kARIQYRi032717@hera.kernel.org>
	<200611301232.57966.jens.wilke@de.ibm.com>
	<a4e6962a0611300824qdfa43cbja783da86fe6eb5cf@mail.gmail.com>
	<200611302107.40418.jens.wilke@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0910868608=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200611302107.40418.jens.wilke@de.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Eric Van Hensbergen <ericvh@hera.kernel.org>, ming@acis.ufl.edu, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--===============0910868608==
Content-Type: multipart/alternative;
	boundary="----=_Part_6950_9762537.1164948550221"

------=_Part_6950_9762537.1164948550221
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 11/30/06, Jens Wilke <jens.wilke@de.ibm.com> wrote:
>
> - You don't keep track of I/O on the fly to the cache that is mapped
> directly in cache_hit(). How do you make sure that this I/O is completed
> before you replace a cache block?


The previous I/O from cache hit and the later I/O for cache replacement
should be queued in order on the cache block device - is this a safe
assumption?


- The cache block index is hashed, this means the cache data blocks are not
> clustered. I don't think you can solve this problem with a proper hash
> function.
> Perhaps you should consider a (B-)Tree structure for that.


The current hash algorithm does clustering to some extent by mapping
consecutive blocks from the source device to consecutive blocks on the cache
device. But I agree that more sophisticated algorithms can be studied.

Thanks a lot for the suggestions. I will try to incorporate them in the next
patch.

- Ming

------=_Part_6950_9762537.1164948550221
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div><span class="gmail_quote">On 11/30/06, <b class="gmail_sendername">Jens Wilke</b> &lt;<a href="mailto:jens.wilke@de.ibm.com">jens.wilke@de.ibm.com</a>&gt; wrote:</span> 
<blockquote class="gmail_quote" style="PADDING-LEFT: 1ex; MARGIN: 0px 0px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">- You don't keep track of I/O on the fly to the cache that is mapped<br>directly in cache_hit(). How do you make sure that this I/O is completed
<br>before you replace a cache block?</blockquote>
<div>&nbsp;</div>
<div>The previous I/O from cache hit and the later I/O for cache replacement should be queued in&nbsp;order on the cache block device - is this a safe assumption?</div>
<div>&nbsp;</div><br>
<blockquote class="gmail_quote" style="PADDING-LEFT: 1ex; MARGIN: 0px 0px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">- The cache block index is hashed, this means the cache data blocks are not<br>clustered. I don't think you can solve this problem with a proper hash function.
<br>Perhaps you should consider a (B-)Tree structure for that.</blockquote>
<div>&nbsp;</div>
<div>The current hash algorithm does clustering to some extent by&nbsp;mapping consecutive blocks&nbsp;from the source device to consecutive blocks&nbsp;on the cache device. But I agree that more sophisticated algorithms can be studied.
</div>
<div>&nbsp;</div>
<div>Thanks a lot for the suggestions. I will try to incorporate them in the next patch.</div>
<div>&nbsp;</div>
<div>- Ming</div></div>

------=_Part_6950_9762537.1164948550221--


--===============0910868608==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0910868608==--
