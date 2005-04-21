From: Arthur Bergman <sky@nanisky.com>
Subject: Re: Making failover work quickly with QLogic HBAs
Date: Thu, 21 Apr 2005 14:21:25 +0100
Message-ID: <b4415a5867f3b25c8166bea8febd4b79@nanisky.com>
References: <20050421122328.GJ17315@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v619.2)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050421122328.GJ17315@marowsky-bree.de>
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


On 21 Apr 2005, at 13:23, Lars Marowsky-Bree wrote:

> This will greatly speed up failover times; with the defaults, the
> timeout values are just way too long for multipathing:
>
> options qla2xxx ql2xfailover=3D0 ql2xioctltimeout=3D10=20
> ql2xprocessnotready=3D0 ql2xloginretrycount=3D3 ql2xsuspendcount=3D3=20
> ql2xretrycount=3D5 qlport_down_retry=3D3
>
>
> Sincerely,
>     Lars Marowsky-Br=E9e <lmb@suse.de>
>
> --=20
> High Availability & Clustering
> SUSE Labs, Research and Development
> SUSE LINUX Products GmbH - A Novell Business
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

There has been discussions that this is not supported behaviour and=20
could cause problems, in particular the supported configurations of big=20
blue for their SDD multipath product states that you shouldn't do=20
this...

Cheers
Arthur

-----
CTO @ Fotango Ltd
+447834716919
http://www.fotango.com/


-----
CTO @ Fotango Ltd
+447834716919
http://www.fotango.com/


______________________________________________________________________
This email has been scanned by the MessageLabs Email Security System.
For more information please visit http://www.messagelabs.com/email=20
______________________________________________________________________
