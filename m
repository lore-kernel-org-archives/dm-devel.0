From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: Re: unmapping luns doesn't work (good)
Date: Thu, 21 Oct 2010 12:58:36 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED704BAAFE3@inbmail01.lsi.com>
References: <4CBC66A3.7020207@UGent.be>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4CBC66A3.7020207@UGent.be>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On  Monday, October 18, 2010 8:54 PM, Rudy Gevaert wrote:
> Case 1:
> -------
> multipath -l
> 
> mail17r-ds3400-1 (3600a0b80005a67b6000004764cac4912) dm-2 
> IBM,1726-4xx 
> FAStT
> size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
> |-+- policy='round-robin 0' prio=-1 status=active
> | `- 0:0:0:6 sde 8:64  active undef running
> `-+- policy='round-robin 0' prio=-1 status=enabled
>    `- 5:0:0:6 sdj 8:144 active undef running
> 
> root@cyrprd1:~# dmsetup table
> mail17r-ds3400-1: 0 1153433600 multipath 1 queue_if_no_path 1 
> rdac 2 1 
> round-robin 0 1 1 8:64 1000 round-robin 0 1 1 8:144 1000
> 
> I now remove mapping through the storage software.

Try with disabling the queuing before removing the map. 
 
dmsetup message mail14r-ds3400-1 0 "fail_if_no_path"
 
> 
> root@cyrprd1:~# multipath -f mail14r-ds3400-1
> Oct 18 17:07:09 | mail14r-ds3400-1: map in use
> 

Regards,
Vijay
