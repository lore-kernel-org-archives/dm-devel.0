From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: racing libdevmapper calls
Date: Wed, 19 Oct 2005 00:30:45 +0200
Message-ID: <1129674646.7313.15.camel@zezette>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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
To: agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

The following command :
# dmsetup remove foo;echo "0 10 linear 8:16 63"|dmsetup create foo &
echo "0 20 linear 8:16 63"|dmsetup create foo

will quite easily produce error message like :
"device-mapper ioctl cmd 3 failed: Device or resource busy"

Is it designed behaviour ?
Can't we expect libdevmapper to serialize its ioctls ?

multipath(8), being run in storms by udev, has trouble with this.
Ideas ?

Regards,
cvaroqui
