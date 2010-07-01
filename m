From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: Rescan for new LUNs
Date: Wed, 30 Jun 2010 18:07:38 -0700
Message-ID: <20100701010738.GA24883@us.ibm.com>
References: <230ED15F81AFD3409345FFA4E565F0E50B83D8E1@NDHV3000.na.corp.mckesson.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <230ED15F81AFD3409345FFA4E565F0E50B83D8E1@NDHV3000.na.corp.mckesson.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Allen, Jack [Jack.Allen@mckesson.com] wrote:
>    Hello:
>    =A0=A0=A0=A0=A0=A0=A0 What is the best way to cause the system to resc=
an for new LUNs,
>    other than rebooting?

Writing something to some files in sysfs. If none of the LUNs are in
use, "modprobe -r <module>" followed by "modprobe <module>" will also
work.

Thanks, Malahal.
