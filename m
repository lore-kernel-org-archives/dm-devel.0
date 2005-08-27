From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [klibc] Re: KLIBC support for device-mapper-1.01.04
Date: Sat, 27 Aug 2005 11:24:32 -0700
Message-ID: <4310AFE0.6040807@zytor.com>
References: <1125005272.7187.49.camel@lycan.lan>
	<1125140561.10188.10.camel@lycan.lan>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1125140561.10188.10.camel@lycan.lan>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: azarah@nosferatu.za.org
Cc: dm-devel@redhat.com, KLIBC Mailing List <klibc@zytor.com>, Christophe Varoqui <christophe.varoqui@free.fr>, Heinz Mauelshagen <mauelshagen@redhat.com>
List-Id: dm-devel.ids

Martin Schlemmer wrote:
> On Thu, 2005-08-25 at 23:28 +0200, Martin Schlemmer wrote:
> 
>>Hi,
>>
>>Some time back I sent a patch for KLIBC support for device-mapper, but
>>no response so far.  I have however updated the patch.
>>
> Ok, I checked multipath-tools again, and did query on the klibc mailing
> lists (no real response), and decided to not have the _klibc suffix on
> the library.  Also tweaked the build to build a binary default linked
> dynamic to klibc, with --enable-static_link giving static linked binary.
> 
> Comments once again welcome.
> 

Sorry for the lack of feedback; I'm a bit backlogged in my life :-/ at 
the moment... I'll try to catch up as soon as possible.

	-hpa
