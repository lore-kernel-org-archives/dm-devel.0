From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: Problem with Multipath (devices not ready)
Date: Thu, 09 Feb 2006 20:43:04 +0100
Message-ID: <43EB9B48.7020707@bzed.de>
References: <!&!AAAAAAAAAAAYAAAAAAAAANNuC7JXowhAhztxsUsdl9nCgAAAEAAAAFrKzybPoitElCE3HsMmQqIBAAAAAA==@est.ips.pt>
	<1139513000.2915.4.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1139513000.2915.4.camel@zezette>
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

Hi,

>>            default_getuid_callout    "/sbin/scsi_id -g -u -s /block/%
>>n"
>>
>>    
>>
>remove too : the CX need a special flag passed to scsi_id if I
>remember ...
>  
>
this was mentioned in a thread about the EMC CX a few weeks ago. But I
think there's also a working default setting for this in multipath (at
least it works very well with the default settings here). Also check
http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=TestedEnvironments
- I've mentioned the neccessary settings on the CX there.


Bernd
