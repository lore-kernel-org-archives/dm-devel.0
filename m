From: "Debarshi 'Rishi' Ray" <debarshi.ray@gmail.com>
Subject: Re: API documentation.
Date: Mon, 16 Oct 2006 21:38:14 +0000
Message-ID: <3170f42f0610161438u19db3bc3tc5a8375075c53b1e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

>> I am looking to incorporate device mapper support
>> in GNU Parted (http://www.gnu.org/software/parted/).

> What specifically needs adding/fixing?

All versions of Parted till 1.7.1 did not work with /dev/mapper devices.
http://lists.gnu.org/archive/html/bug-parted/2006-09/msg00028.html

But it seems 1.8.0rc2 has some support (courtesy David Cantrell). I
have not tried it though.

Regards,
Debarshi
-- 
"India is not, as people keep calling it, an underdeveloped country,
but rather a developed nation in an advanced state of decay."
--Shashi Tharoor
