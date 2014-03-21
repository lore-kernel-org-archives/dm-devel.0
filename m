From: Matias Bjorling <m@bjorling.me>
Subject: Re: [dm-devel] [PATCH RFC v1 00/01] dm-lightnvm introduction
Date: Fri, 21 Mar 2014 08:22:24 -0700
Message-ID: <532C5930.7040107@bjorling.me>
References: <1395383538-18019-1-git-send-email-m@bjorling.me> <20140321090630.GA30044@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140321090630.GA30044@debian>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, snitzer@redhat.com, agk@redhat.com, neilb@suse.de, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 03/21/2014 02:06 AM, Joe Thornber wrote:
> Hi Matias,
>=20
> This looks really interesting and I'd love to get involved.  Do you
> have any recommendations for what hardware I should pick up?

Hi Joe,

The most easily available platform is OpenSSD
(http://www.openssd-project.org). It's a little old, but still very
functional. When there's a good firmware implementation, I think it wil=
l
be easier for the custom SSD vendor's to jump on board with their own
firmware.

- Matias

>=20
> - Joe
>=20
>=20
> On Thu, Mar 20, 2014 at 11:32:17PM -0700, Matias Bj=F8rling wrote:
>> Hi,
>>
>> Users that have custom firmware SSDs, may choose to expose their fla=
sh directly.
>> This allows the host to control logical to physical address mappings=
, garbage
>> collection strategy, wear-leveling, and so on.
