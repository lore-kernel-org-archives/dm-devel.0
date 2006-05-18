From: Luca Berra <bluca@comedia.it>
Subject: Re: Re: [Consult-list] dm-multipath has great throughput
	but we'd like more!
Date: Thu, 18 May 2006 09:27:50 +0200
Message-ID: <20060518072749.GC26035@percy.comedia.it>
References: <1147935929.27006.57.camel@baggage>
	<1147936749.27006.59.camel@baggage>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1147936749.27006.59.camel@baggage>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: rgautier@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, May 18, 2006 at 08:19:09AM +0100, Bob Gautier wrote:
>On Thu, 2006-05-18 at 08:05 +0100, Bob Gautier wrote:
>> Yesterday my client was testing of multipath load balancing and failover
>> on a system running ext3 on a logical volume which comprises about ten
>> SAN LUNs all reached using multipath in multibus mode over two QL2340
>> HBAs.
>
>Sorry, should have also said: RHEL4u3 x86_64 on DL385 with 16Gb memory
>
you could have added the storage model :)
btw did you do any tuning (i.e. readhaead, scheduler) ?

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
