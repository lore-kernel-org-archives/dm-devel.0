From: Roland PJ <roland@rolandpj.com>
Subject: Re: Re: device mapper integrated loops - and one more
	year !
Date: Tue, 21 Nov 2006 23:55:27 +0200
Message-ID: <456375CF.10006@rolandpj.com>
References: <1439173022@web.de> <45636B89.7080407@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <45636B89.7080407@redhat.com>
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
List-Id: dm-devel.ids

Hi Bryn

Just to avoid confusion, this is a different Roland from the original query.

Looking at 
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-loop.patch

+			if (!cur_block)
+				goto bad_bmap;

...

+bad_bmap:
+	DMERR("Loopfile has holes");
+	dump_extent_map(map);

Does this mean that dm-loop does not support sparse loop-back files?

Also, it seems that the approach with dm-loop is that you sniff the (current?) file mapping onto its underlying block device. What happens if the loopback file is modified, or the file system hosting the loopback file does some re-arranging? (I might be way off-tack here - this was a first impression of the code).

I'd be interested in comparing dm-loop to vanilla loop which we currently use.

Regards
Roland #2


>  
>
