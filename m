From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [dm-crypt] [dm-devel] dm-crypt performance
Date: Tue, 09 Apr 2013 20:59:27 +0200
Message-ID: <5164650F.50405@gmail.com>
References: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com> <20130326122713.GC27610@agk-dp.fab.redhat.com> <5151FF82.6090405@gmail.com> <Pine.LNX.4.64.1304091352320.10025@file.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1304091352320.10025@file.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Milan Broz <gmazyland@gmail.com>, Mike Snitzer <msnitzer@redhat.com>, dm-crypt@saout.de, Christian Schmidt <schmidt@digadd.de>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>
List-Id: dm-devel.ids

On 9.4.2013 20:08, Mikulas Patocka wrote:
> 
> 
> On Tue, 26 Mar 2013, Milan Broz wrote:
> 
>> - Are we sure we are not inroducing some another side channel in disc
>> encryption? (Unprivileged user can measure timing here).
>> (Perhaps stupid reason but please do not prefer performance to security
>> in encryption. Enough we have timing attacks for AES implementations...)
> 
> So use serpent - it is implemented without any data-dependent lookup 
> tables, so it has no timing attacks.

I wish using something different than AES is just such simple technical issue
for many people. But e.g. just try it in FIPS mode where AES is the only option:-)

Anyway, using bio_associate_current() seems to be the right way to try now...

Milan
