From: Andreas Hartmann <andihartmann@freenet.de>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
 READ FPDMA QUEUED errors since Linux 4.0
Date: Fri, 31 Jul 2015 10:15:17 +0200
Message-ID: <55BB2E95.7000601@maya.org>
References: <55B7BEA2.30205@01019freenet.de>
 <20150728175054.GB24782@redhat.com> <55B7C800.2070702@maya.org>
 <20150728185811.GA25060@redhat.com> <55B7D6BE.5010203@maya.org>
 <20150728193101.GB25264@redhat.com> <55B7E14A.4050500@maya.org>
 <20150728212441.GA25761@redhat.com> <55B87005.7010409@redhat.com>
 <55B8759B.8070400@redhat.com> <55B90C25.8030502@maya.org>
 <55BA895D.30509@maya.org> <55BB2284.1060706@redhat.com>
 <55BB2A02.70700@maya.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <55BB2A02.70700@maya.org>
Sender: linux-pci-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>, device-mapper development <dm-devel@redhat.com>, Ondrej Kozina <okozina@redhat.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Mike Snitzer <msnitzer@redhat.com>, mpatocka@redhat.com
List-Id: dm-devel.ids

On 07/31/2015 at 09:55 AM Andreas Hartmann wrote:
> On 07/31/2015 at 09:23 AM, Milan Broz wrote:
>> On 07/30/2015 10:30 PM, Andreas Hartmann wrote:
[...]
>>> - rotational disks alone: it's ok
>>> - more than 3 partitions on ssd Corsair Force GT -> broken
>>> - more than 3 partitions on ssd KINGSTON SV300S37A240G -> broken
>>
>> - if you disable NCQ, the problems goes away?
> 
> As I already wrote in another post - than other error came up instead
> (radeon). But I will try it especially again in conjunction w/
> --perf-submit_from_crypt_cpus --perf-same_cpu_crypt.

Combining all three options (noncq, --perf-submit_from_crypt_cpus and
--perf-same_cpu_crypt) seem to "work".


Regards,
Andreas
