From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [PATCH]  rm alloc_page from dm-emc take 2
Date: Mon, 11 Apr 2005 04:48:12 -0700
Message-ID: <425A63FC.1060808@us.ibm.com>
References: <425A6145.7010302@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <425A6145.7010302@cs.wisc.edu>
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
Cc: Lars Marowsky-Bree <lmb@suse.de>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Mike Christie wrote:
> I am not sure if the first mail got sent out. Here is
> the correct mail with the patch.
> 
> Hey Lars,
> 
> Here is what I meant. A Page for just something around 8-16 bytes
> seems wasteful. Plus there is no reserve.
> 
> If you have to end up setting more bits maybe it is better to
> preallocate a command per device at create time, or maybe since
> there are four different combos I should have done it with this
> patch?
> 
> This was made against 2.6.12-rc2. Only compile tested.
> 
> Mike
> 




> +	if (bio_add_page(bio, virt_to_page(data), data_size,
> +			 offset_in_page(data)) != data_size) {

My concern though is that I do no think I can do this. I mean we cannot 
start the IO from the middle of a page.
