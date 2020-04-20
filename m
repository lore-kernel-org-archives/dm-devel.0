From: Ondrej Kozina <okozina@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/3] dm raid/raid1: enable discard support when
 any devices support discard
Date: Mon, 20 Apr 2020 12:22:59 +0200
Message-ID: <6e458e2a-f8aa-d6e3-0e6d-7c11ad2a6825@redhat.com>
References: <20200419073026.197967-1-pabs3@bonedaddy.net>
 <20200419131908.GA22398@redhat.com>
 <9cb6a39a43178be29af2f47a92c2e84754b62b69.camel@bonedaddy.net>
 <6bbf9d94-2fbb-f96f-ea85-a480ba109c55@redhat.com>
 <a0034feda1f6f598c8376a418949b48109307e67.camel@bonedaddy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a0034feda1f6f598c8376a418949b48109307e67.camel@bonedaddy.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Wise <pabs3@bonedaddy.net>, dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 4/20/20 12:13 PM, Paul Wise wrote:
> On Mon, 2020-04-20 at 09:35 +0200, Ondrej Kozina wrote:
> 
>> Did you have discard allowed on both dm-crypt devices? dm-crypt
>> (kernel) does not allow discards by default.
> 
> I did not, I guess that explains why I got no errors.
> 

FYI if you use LUKS2 metadata format for encrypted drives, you can 
enable discards by default once and for all by following command:

cryptsetup open /dev/sdx sdx_unlocked --allow-discards --persistent

Any following unlock will enable discards automatically.

Regards O.
