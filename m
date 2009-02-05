From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Multipath setup and rdac questions
Date: Thu, 05 Feb 2009 19:11:38 +0000
Message-ID: <498B39EA.1070903@redhat.com>
References: <1a4a774c0902050558r661093dag83e71a06250c24aa@mail.gmail.com>	<498B00B3.5020402@redhat.com>
	<1a4a774c0902051048keb6e681g7dbf2643a88a6d9e@mail.gmail.com>
Reply-To: bmr@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1a4a774c0902051048keb6e681g7dbf2643a88a6d9e@mail.gmail.com>
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

Christian R=F8snes wrote:
> Is mpp another type of rdac driver than the one in question here ?

I have no real experience with MPP so there are probably others who=20
can give more details but MPP is an entirely separate 3rd-party=20
multipath driver framework, a bit like EMC's PowerPath or other=20
vendor's multipathing solutions. Afaik, it supports several types of=20
device including RDAC.

Part of your problem appears to be that you are trying to use /both/=20
mpp and device-mapper multipath on the same system at the same time.=20
Since they both try to do the same job this is guaranteed to lead to=20
problems - you need to chose one or the other & get it correctly=20
configured for your hardware.

Regards,
Bryn.
