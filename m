From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: How does multipath tool handle Lun remapping?
Date: Tue, 20 Jan 2009 10:44:00 -0500
Message-ID: <20090120154400.GA19640@mars.virtualiron.com>
References: <d364733c0901160042n65184828pcac1e7a6435b6c9c@mail.gmail.com>
	<20090116181327.GD1493@mars.virtualiron.com>
	<d364733c0901191917y76543be4o5b14f29c057d1bd5@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <d364733c0901191917y76543be4o5b14f29c057d1bd5@mail.gmail.com>
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

On Tue, Jan 20, 2009 at 11:17:53AM +0800, =E8=B0=A2=E7=BA=B2 wrote:
> It make sense that multipath tool can notice that there is a
> recreation of OS device. But it still depends on the external program,
> such as scsi_id to get the identifier of the lun=E3=80=82
> I looked through the scsi_id source code, found that unit serial
> number might be returned if the device supported the EVPD inquery
> page80. This might be the wrong infomation for multipath tool, is that
> true?

That information is correct. You can prove it yourself by running
'scsi_id -g -u -s /block/sdb' before and after the deletion. The
value will be the same.


What is not correct is the LUN number. And for that there needs
to be a deletion of the block device and a recreation of them.
