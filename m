From: Levy_Jerome@emc.com
Subject: Re: Can SCSI commands trigger the reinit of a disabled
	path?
Date: Wed, 10 Jun 2009 12:35:13 -0400
Message-ID: <6416EE16C1AF1E4C86882867E4DD0FF605C111AF@CORPUSMX40B.corp.emc.com>
References: <20090610160044.57D8B619E37@hormel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20090610160044.57D8B619E37@hormel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

> I went through the multipath code and found there was hardware handler
> for specified hardware, such as emc.  When init path, it will use the
> trespass command given by the handler. Does this mean it only support
> the A/PF mode of array? When SCSI commands,  such as SCSI PR, are sent
> to a disabled path, will trespass be triggered?=20

In A/PF mode, with failovermode set to 1 (as it should be for dm-mpio)=20
the Clariion array will only trespass LUNs on receipt of an explicit=20
trespass command, not on other I/O.=20

Jerry Levy, EMC
