From: "Scott Moseman" <scmoseman@gmail.com>
Subject: Re: Creation of the mpath# devices
Date: Mon, 19 Nov 2007 09:30:27 -0600
Message-ID: <342d47870711190730m57badf48jf0c3758f5b4dde31@mail.gmail.com>
References: <342d47870711151302o68e3172fn92c8c1e323812905@mail.gmail.com>
	<20071115212943.GF4900@ether.msp.redhat.com>
	<342d47870711151436l1f49e2d3od0aa6e99bd599b37@mail.gmail.com>
	<5fb0f77b0711160555n2fc523a3v44650307911ec489@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5fb0f77b0711160555n2fc523a3v44650307911ec489@mail.gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Nov 16, 2007 7:55 AM, Kevin Foote <kevin.foote@gmail.com> wrote:
>
> What does your output of this command show.. just currious as I have
> multiple devices on an equallogic and I'm trying to figure out an issue
> with multipath thinking the path is down when its not..
>
> command => dmsetup table /dev/mapper/<yourdevice>
>

For what it's worth...

# dmsetup table /dev/mapper/mpath0
0 8417280 multipath 0 0 2 1 round-robin 0 1 1 8:32 100 round-robin 0 1
1 8:16 100

Thanks,
Scott
