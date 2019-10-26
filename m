From: "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
Subject: dm-zoned performance degradation after apply
 75d66ffb48efb3 ("dm zoned:, properly handle backing device failure")
Date: Sat, 26 Oct 2019 09:56:50 +0800
Message-ID: <203cc4c8-b380-5b2f-c9e7-766b3f031c8c@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dmitry.fomichev@wdc.com, damien.lemoal@wdc.com, snitzer@redhat.com, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi all, when I 'mkfs.ext4' on the dmz device based on 10T smr disk,
it takes more than 10 hours after apply 75d66ffb48efb3 ("dm zoned:
properly handle backing device failure").

After delete the 'check_events' in 'dmz_bdev_is_dying', it just
take less than 12 mins.

I test it based on 4.19 branch.
Must we do the 'check_events' at mapping path, reclaim or metadata I/O?

Thanks.
