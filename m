From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: Changes to readsector0
Date: Tue, 8 Jul 2008 10:00:28 -0400
Message-ID: <20080708140028.GB6764@mars.virtualiron.com>
References: <A7519D7FDEF2A144BA6D40BDF13100FE8FEE46@ex2.Beer.Town>
	<1D80D4F6D179BD4D869FE807A5BF833602D8B643@EXCNYSM0A1AN.nysemail.nyenet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1D80D4F6D179BD4D869FE807A5BF833602D8B643@EXCNYSM0A1AN.nysemail.nyenet>
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

On Tue, Jul 08, 2008 at 08:41:48AM -0400, Romanowski, John (OFT) wrote:
> Hi,
>  I use readsector0, moving to SLES10 SP2 soon  and am interested in you=
r
> problem description.

The manpage for SLES10 SP2 multipath.conf mentions this:

" path_checker     The default method used to determine the paths=E2=80=99=
 state. Possible values are

                        directio    Read the first sector with direct I/O=
.

						.... snip ..

                        readsector0 (Deprecated) Read the first sector of=
 the device.

                        Default value is directio. Using readsector0 as
                        path_checker is deprecated as it=E2=80=99s report=
ed to not work correctly on certain devices.
"


So you should be able to replace 'readsector0' with 'directio' in your mu=
ltipath.conf file.
