From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: 3PAR transparent failover with Linux
Date: Wed, 24 Sep 2014 09:10:15 +0200
Message-ID: <20140924071015.GA15843@glanzmann.de>
References: <20140911125818.GC29930@glanzmann.de>
	<20140924001144.00007453@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140924001144.00007453@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello Sebastian,

* Sebastian Herbszt <herbszt@gmx.de> [2014-09-24 00:14]:
> What is the output of "sg_rtpg -d" for all paths before and after the
> failover?

I took this information only after the failover:

Report target port groups:
  target port group id : 0x102 , Pref=0
    target port group asymmetric access state : 0x02
    T_SUP : 1, O_SUP : 0, LBD_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
    status code : 0x00
    vendor unique status : 0x00
    target port count : 14
    Relative target port ids:
      0x7db
      0x7dc
      0x7e5
      0x7e6
      0x7e7
      0x83f
      0x840
      0x849
      0x84a
      0x84c
      0x8a3
      0x8a4
      0x8ad
      0x8ae
      0x8af
      0x907
      0x908
      0x911
      0x912
      0x914
  target port group id : 0x101 , Pref=1
    target port group asymmetric access state : 0x00
    T_SUP : 1, O_SUP : 0, LBD_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
    status code : 0x00
    vendor unique status : 0x00
    target port count : 10
    Relative target port ids:
      0x3f3
      0x3f4
      0x3fd
      0x3fe
      0x457
      0x458
      0x461
      0x462
      0x4bb
      0x4bc
      0x4c5
      0x4c6
      0x51f
      0x520
      0x529
      0x52a
Report target port groups:
  target port group id : 0x102 , Pref=0
    target port group asymmetric access state : 0x02
    T_SUP : 1, O_SUP : 0, LBD_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
    status code : 0x00
    vendor unique status : 0x00
    target port count : 14
    Relative target port ids:
      0x7db
      0x7dc
      0x7e5
      0x7e6
      0x7e7
      0x83f
      0x840
      0x849
      0x84a
      0x84c
      0x8a3
      0x8a4
      0x8ad
      0x8ae
      0x8af
      0x907
      0x908
      0x911
      0x912
      0x914
  target port group id : 0x101 , Pref=1
    target port group asymmetric access state : 0x00
    T_SUP : 1, O_SUP : 0, LBD_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
    status code : 0x00
    vendor unique status : 0x00
    target port count : 10
    Relative target port ids:
      0x3f3
      0x3f4
      0x3fd
      0x3fe
      0x457
      0x458
      0x461
      0x462
      0x4bb
      0x4bc
      0x4c5
      0x4c6
      0x51f
      0x520
      0x529
      0x52a
Report target port groups:
  target port group id : 0x101 , Pref=1
    target port group asymmetric access state : 0x00
    T_SUP : 1, O_SUP : 0, LBD_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
    status code : 0x00
    vendor unique status : 0x00
    target port count : 14
    Relative target port ids:
      0x3f3
      0x3f4
      0x3fd
      0x3fe
      0x3ff
      0x457
      0x458
      0x461
      0x462
      0x464
      0x4bb
      0x4bc
      0x4c5
      0x4c6
      0x4c7
      0x51f
      0x520
      0x529
      0x52a
      0x52c
  target port group id : 0x102 , Pref=0
    target port group asymmetric access state : 0x02
    T_SUP : 1, O_SUP : 0, LBD_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
    status code : 0x00
    vendor unique status : 0x00
    target port count : 10
    Relative target port ids:
      0x7db
      0x7dc
      0x7e5
      0x7e6
      0x83f
      0x840
      0x849
      0x84a
      0x8a3
      0x8a4
      0x8ad
      0x8ae
      0x907
      0x908
      0x911
      0x912
Report target port groups:
  target port group id : 0x101 , Pref=1
    target port group asymmetric access state : 0x00
    T_SUP : 1, O_SUP : 0, LBD_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
    status code : 0x00
    vendor unique status : 0x00
    target port count : 14
    Relative target port ids:
      0x3f3
      0x3f4
      0x3fd
      0x3fe
      0x3ff
      0x457
      0x458
      0x461
      0x462
      0x464
      0x4bb
      0x4bc
      0x4c5
      0x4c6
      0x4c7
      0x51f
      0x520
      0x529
      0x52a
      0x52c
  target port group id : 0x102 , Pref=0
    target port group asymmetric access state : 0x02
    T_SUP : 1, O_SUP : 0, LBD_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
    status code : 0x00
    vendor unique status : 0x00
    target port count : 10
    Relative target port ids:
      0x7db
      0x7dc
      0x7e5
      0x7e6
      0x83f
      0x840
      0x849
      0x84a
      0x8a3
      0x8a4
      0x8ad
      0x8ae
      0x907
      0x908
      0x911
      0x912

Cheers,
        Thomas
