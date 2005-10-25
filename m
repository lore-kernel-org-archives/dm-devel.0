From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: RAID5 support ?
Date: Tue, 25 Oct 2005 17:12:53 +0200
Message-ID: <62b0912f0510250812l3a9ab85bo7887fc07b9c5cb44@mail.gmail.com>
References: <1129981242.7217.6.camel@jetpack.demon.co.uk>
	<17242.17266.315175.852854@cse.unsw.edu.au>
	<1129996688.7217.9.camel@jetpack.demon.co.uk>
	<17244.8868.117125.78408@cse.unsw.edu.au>
	<20051025144107.GA3522@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20051025144107.GA3522@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mauelshagen@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Heinz Mauelshagen wrote:
> FYI: we keep information about which regions (arbitrary sized segments
>      of the address space) of the set are dirty with the the
>      device-mapper dirty-log so that we can resynchonize those at set s=
tartup.

Sounds sort of nasty.
What happens if the user boots to Windows in the mean time?
Windows will see corrupted data?

(I mean, that's the whole point of using a hardware soft-RAID
solution, isn't it?  BIOS and multiple-OS support for the metadata
format / RAID arrays?)
