From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [git pull] device mapper changes for 5.8
Date: Fri, 5 Jun 2020 14:17:13 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006051412360.20164@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200605145124.GA31972@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200605145124.GA31972@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I'd like to ask to remove these two patches:

>       dm crypt: sleep and retry on allocation errors
>       dm integrity: sleep and retry on allocation errors

Retrying the request in dm-crypt is not safe because crypt_convert_block 
already advanced to the next block (even in the case of allocation failure 
and an error).

We must retry in crypt_convert_block_skcipher, now I am trying to find out 
how to do it properly.

Mikulas
