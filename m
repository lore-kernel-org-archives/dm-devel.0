From: Ondrej Kozina <okozina@redhat.com>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
 READ FPDMA QUEUED errors since Linux 4.0
Date: Wed, 29 Jul 2015 08:17:41 +0200
Message-ID: <55B87005.7010409@redhat.com>
References: <55B7BEA2.30205@01019freenet.de>
 <20150728175054.GB24782@redhat.com> <55B7C800.2070702@maya.org>
 <20150728185811.GA25060@redhat.com> <55B7D6BE.5010203@maya.org>
 <20150728193101.GB25264@redhat.com> <55B7E14A.4050500@maya.org>
 <20150728212441.GA25761@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20150728212441.GA25761@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Andreas Hartmann <andihartmann@freenet.de>
Cc: linux-pci <linux-pci@vger.kernel.org>, mpatocka@redhat.com, Milan Broz <mbroz@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

On 07/28/2015 11:24 PM, Mike Snitzer wrote:
>>
>> I am willing to do tests if you have any idea to be tested - I can
>> reproduce it quite easily.
>
> You can try disabling dm-crypt's parallelization by specifying these 2
> features: same_cpu_crypt submit_from_crypt_cpus
>

Hi,

please try adding follwoing cryptsetup perf. options while unlocking 
your LUKS containers: --perf-submit_from_crypt_cpus and 
--perf-same_cpu_crypt.

Perhaps focus on SSD disk as previous unresolved report mentioned SSD too

Regards
O.
