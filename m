From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: (no subject)
Date: Thu, 14 Sep 2006 15:05:58 -0700
Message-ID: <4509D246.7010803@us.ibm.com>
References: <8859E1A9-9C74-4188-A678-F97FD77A86FF@ysbl.york.ac.uk>
	<20060914134154.GC6045@jam.ts>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060914134154.GC6045@jam.ts>
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

Mr. Kirk,

> Sounds like dmraid is grabbing them.  I'm not sure where the configurat=
ion for
> dmraid is, but that's a starting point.

I think FC5 runs "dmraid -ay" automatically, which probes disks and sets
up device-mapper configurations.  However, to ensure that this is really
dmraid's fault, could you post the output of "dmsetup table" after you
boot the system (and before you blow away the dm devices, obviously)?

If it _is_ dmraid, then you'll want to clean out any RAID configurations
in the SATA BIOS, and/or run dmraid -E /dev/sdX to remove the dmraid
configuration data.

Thanks,

--Darrick
