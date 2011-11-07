From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Subject: Error when compiling drivers/md/dm-bufio.c
Date: Mon, 7 Nov 2011 09:22:31 +0100
Message-ID: <20111107082231.GB18221@smp.if.uj.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

I just got error on todays Linus' tree


  CC [M]  drivers/md/dm-bufio.o
drivers/md/dm-bufio.c:988:1: warning: data definition has no type or st=
orage class [enabled by default]
drivers/md/dm-bufio.c:988:1: warning: type defaults to =E2=80=98int=E2=80=
=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wimplicit-i=
nt]
drivers/md/dm-bufio.c:988:1: warning: parameter names (without types) i=
n function declaration [enabled by default]
drivers/md/dm-bufio.c:997:1: warning: data definition has no type or st=
orage class [enabled by default]
drivers/md/dm-bufio.c:997:1: warning: type defaults to =E2=80=98int=E2=80=
=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wimplicit-i=
nt]
drivers/md/dm-bufio.c:997:1: warning: parameter names (without types) i=
n function declaration [enabled by default]
drivers/md/dm-bufio.c:1006:1: warning: data definition has no type or s=
torage class [enabled by default]
drivers/md/dm-bufio.c:1006:1: warning: type defaults to =E2=80=98int=E2=
=80=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wimplici=
t-int]
drivers/md/dm-bufio.c:1006:1: warning: parameter names (without types) =
in function declaration [enabled by default]
drivers/md/dm-bufio.c:1036:1: warning: data definition has no type or s=
torage class [enabled by default]
drivers/md/dm-bufio.c:1036:1: warning: type defaults to =E2=80=98int=E2=
=80=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wimplici=
t-int]
drivers/md/dm-bufio.c:1036:1: warning: parameter names (without types) =
in function declaration [enabled by default]
drivers/md/dm-bufio.c:1049:1: warning: data definition has no type or s=
torage class [enabled by default]
drivers/md/dm-bufio.c:1049:1: warning: type defaults to =E2=80=98int=E2=
=80=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wimplici=
t-int]
drivers/md/dm-bufio.c:1049:1: warning: parameter names (without types) =
in function declaration [enabled by default]
drivers/md/dm-bufio.c:1059:1: warning: data definition has no type or s=
torage class [enabled by default]
drivers/md/dm-bufio.c:1059:1: warning: type defaults to =E2=80=98int=E2=
=80=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wimplici=
t-int]
drivers/md/dm-bufio.c:1059:1: warning: parameter names (without types) =
in function declaration [enabled by default]
drivers/md/dm-bufio.c:1135:1: warning: data definition has no type or s=
torage class [enabled by default]
drivers/md/dm-bufio.c:1135:1: warning: type defaults to =E2=80=98int=E2=
=80=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wimplici=
t-int]
drivers/md/dm-bufio.c:1135:1: warning: parameter names (without types) =
in function declaration [enabled by default]
drivers/md/dm-bufio.c:1158:1: warning: data definition has no type or s=
torage class [enabled by default]
drivers/md/dm-bufio.c:1158:1: warning: type defaults to =E2=80=98int=E2=
=80=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wimplici=
t-int]
drivers/md/dm-bufio.c:1158:1: warning: parameter names (without types) =
in function declaration [enabled by default]
drivers/md/dm-bufio.c:1232:1: warning: data definition has no type or s=
torage class [enabled by default]
drivers/md/dm-bufio.c:1232:1: warning: type defaults to =E2=80=98int=E2=
=80=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wimplici=
t-int]
drivers/md/dm-bufio.c:1232:1: warning: parameter names (without types) =
in function declaration [enabled by default]
drivers/md/dm-bufio.c:1238:1: warning: data definition has no type or s=
torage class [enabled by default]
drivers/md/dm-bufio.c:1238:1: warning: type defaults to =E2=80=98int=E2=
=80=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wimplici=
t-int]
drivers/md/dm-bufio.c:1238:1: warning: parameter names (without types) =
in function declaration [enabled by default]
drivers/md/dm-bufio.c:1245:1: warning: data definition has no type or s=
torage class [enabled by default]
drivers/md/dm-bufio.c:1245:1: warning: type defaults to =E2=80=98int=E2=
=80=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wimplici=
t-int]
drivers/md/dm-bufio.c:1245:1: warning: parameter names (without types) =
in function declaration [enabled by default]
drivers/md/dm-bufio.c:1251:1: warning: data definition has no type or s=
torage class [enabled by default]
drivers/md/dm-bufio.c:1251:1: warning: type defaults to =E2=80=98int=E2=
=80=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wimplici=
t-int]
drivers/md/dm-bufio.c:1251:1: warning: parameter names (without types) =
in function declaration [enabled by default]
drivers/md/dm-bufio.c:1257:1: warning: data definition has no type or s=
torage class [enabled by default]
drivers/md/dm-bufio.c:1257:1: warning: type defaults to =E2=80=98int=E2=
=80=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wimplici=
t-int]
drivers/md/dm-bufio.c:1257:1: warning: parameter names (without types) =
in function declaration [enabled by default]
drivers/md/dm-bufio.c:1263:1: warning: data definition has no type or s=
torage class [enabled by default]
drivers/md/dm-bufio.c:1263:1: warning: type defaults to =E2=80=98int=E2=
=80=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wimplici=
t-int]
drivers/md/dm-bufio.c:1263:1: warning: parameter names (without types) =
in function declaration [enabled by default]
drivers/md/dm-bufio.c:1269:1: warning: data definition has no type or s=
torage class [enabled by default]
drivers/md/dm-bufio.c:1269:1: warning: type defaults to =E2=80=98int=E2=
=80=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wimplici=
t-int]
drivers/md/dm-bufio.c:1269:1: warning: parameter names (without types) =
in function declaration [enabled by default]
drivers/md/dm-bufio.c:1489:1: warning: data definition has no type or s=
torage class [enabled by default]
drivers/md/dm-bufio.c:1489:1: warning: type defaults to =E2=80=98int=E2=
=80=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wimplici=
t-int]
drivers/md/dm-bufio.c:1489:1: warning: parameter names (without types) =
in function declaration [enabled by default]
drivers/md/dm-bufio.c:1534:1: warning: data definition has no type or s=
torage class [enabled by default]
drivers/md/dm-bufio.c:1534:1: warning: type defaults to =E2=80=98int=E2=
=80=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wimplici=
t-int]
drivers/md/dm-bufio.c:1534:1: warning: parameter names (without types) =
in function declaration [enabled by default]
drivers/md/dm-bufio.c:1676:63: error: expected =E2=80=98)=E2=80=99 befo=
re =E2=80=98ulong=E2=80=99
drivers/md/dm-bufio.c:1677:40: error: expected =E2=80=98)=E2=80=99 befo=
re string constant
drivers/md/dm-bufio.c:1679:55: error: expected =E2=80=98)=E2=80=99 befo=
re =E2=80=98uint=E2=80=99
drivers/md/dm-bufio.c:1680:35: error: expected =E2=80=98)=E2=80=99 befo=
re string constant
drivers/md/dm-bufio.c:1682:67: error: expected =E2=80=98)=E2=80=99 befo=
re =E2=80=98ulong=E2=80=99
drivers/md/dm-bufio.c:1683:40: error: expected =E2=80=98)=E2=80=99 befo=
re string constant
drivers/md/dm-bufio.c:1685:79: error: expected =E2=80=98)=E2=80=99 befo=
re =E2=80=98ulong=E2=80=99
drivers/md/dm-bufio.c:1686:46: error: expected =E2=80=98)=E2=80=99 befo=
re string constant
drivers/md/dm-bufio.c:1688:87: error: expected =E2=80=98)=E2=80=99 befo=
re =E2=80=98ulong=E2=80=99
drivers/md/dm-bufio.c:1689:50: error: expected =E2=80=98)=E2=80=99 befo=
re string constant
drivers/md/dm-bufio.c:1691:73: error: expected =E2=80=98)=E2=80=99 befo=
re =E2=80=98ulong=E2=80=99
drivers/md/dm-bufio.c:1692:43: error: expected =E2=80=98)=E2=80=99 befo=
re string constant
drivers/md/dm-bufio.c:1694:73: error: expected =E2=80=98)=E2=80=99 befo=
re =E2=80=98ulong=E2=80=99
drivers/md/dm-bufio.c:1695:43: error: expected =E2=80=98)=E2=80=99 befo=
re string constant
drivers/md/dm-bufio.c:1697:15: error: expected declaration specifiers o=
r =E2=80=98...=E2=80=99 before string constant
drivers/md/dm-bufio.c:1698:20: error: expected declaration specifiers o=
r =E2=80=98...=E2=80=99 before string constant
drivers/md/dm-bufio.c:1699:16: error: expected declaration specifiers o=
r =E2=80=98...=E2=80=99 before string constant
make[2]: *** [drivers/md/dm-bufio.o] B=C5=82=C4=85d 1
make[1]: *** [drivers/md] B=C5=82=C4=85d 2
make: *** [drivers] B=C5=82=C4=85d 2

COde is new, so it probably new bug not regression.

Regards,
Witek



--=20
Witold Baryluk
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
