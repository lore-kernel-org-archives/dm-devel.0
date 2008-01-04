From: Andrea Cavallari <acavalla@redhat.com>
Subject: Using dmsetup suspend / resume
Date: Fri, 04 Jan 2008 16:24:58 -0200
Message-ID: <477E79FA.4060108@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
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

Hello people.

I need some help.
There is a customer using the command "dmsetup suspend" in order to=20
flush and suspend any  I/O that has already been mapped by the device=20
but has not yet completed flushed during an snapshot execution with a HP=20
tool.

The question is: After execute the command "dmsetup resume" (to=20
un-suspends  a  device) the data integrity is guaranteed?

There is any problem related to the file system integrity?

The snapshot process takes about 10 seconds.

Any documentation is good too!

Thanks,

--=20
Att.
Andr=E9a Cavallari
Support Engineer - Global Support Services
Red Hat Brasil - http://www.br.redhat.com
Fone: 55 11 3529-6000=20
