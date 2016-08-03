From: james harvey <jamespharvey20@gmail.com>
Subject: Re: During systemd/udev,
	device-mapper trying to work with non-LVM volumes
Date: Tue, 2 Aug 2016 22:15:59 -0400
Message-ID: <CA+X5Wn7KCwnuM-rzkPpv9v005tLVvVthJkcDxV2vTBz0AXj8Pw@mail.gmail.com>
References: <CA+X5Wn5tbL02XpG-JMvZ4-Sdg+sv=yymD1s6Afboag59LqD94Q@mail.gmail.com>
	<4d36f133-5e8f-3e89-9038-5268b7b6f770@redhat.com>
	<CA+X5Wn5nZjyC2qk7yDYkMH+LX6kznjoEcubcMjC7tgN+k5vfbw@mail.gmail.com>
	<3608c518-ab93-c7fd-9dad-49650d234de6@redhat.com>
	<CA+X5Wn6L4kvgOkBx2=M97ni=C-WaZuq0+CiuYv1UJr8ZLu1C0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+X5Wn6L4kvgOkBx2=M97ni=C-WaZuq0+CiuYv1UJr8ZLu1C0g@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>, Marian Csontos <mcsontos@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

> # pvcreate /dev/disk/sda3
> # vgcreate disk1 /dev/disk/sda3
> # pvcreate /dev/disk/sdb3
> # vgcreate disk2 /dev/disk/sdb3
> # pvcreate /dev/disk/sdc3
> # vgcreate disk3 /dev/disk/sdc3

... I'm actually using
/dev/disk/by-id/ata-TOSHIBA_MD04ACA500_<serialNumber> but shortened
for simplicity and missed removing the /disk/ portion.
