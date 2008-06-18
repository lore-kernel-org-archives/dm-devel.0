From: Roman Himmes <roman.himmes@post.rwth-aachen.de>
Subject: DMRAID with GB-P35-DS4 and Intel ICH9R
Date: Wed, 18 Jun 2008 14:44:29 +0200
Message-ID: <5808893E-E010-441B-88C5-322F34B84DA8@post.rwth-aachen.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_oXkzemhCAfUZ2x5KqBZkgw)"
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


--Boundary_(ID_oXkzemhCAfUZ2x5KqBZkgw)
Content-type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-transfer-encoding: 7BIT

Hi,

with the current kubuntu 8.04 (did not try others) I could not  
recognize my RAID0 Partition.

I have two SATA Hard diskc on my Intel ICH9R Controller, dmraid finds  
the requested partitions but I cannot activate them.

After Booting Kubuntu live CD the Raid Bios recognizes the two disks  
as offlinbe members. A cold start sets them again to the correct RAID0  
state.

Attached to this post there are the output files of

dmraid -rD
dmraid -r
and
dmraid -ay -vvv -d


Can you help me?

Greetings,

Roman Himmes



--Boundary_(ID_oXkzemhCAfUZ2x5KqBZkgw)
Content-type: application/octet-stream; x-unix-mode=0644;
	name=GB-PE35-DS4.tar.bz2
Content-transfer-encoding: base64
Content-disposition: attachment; filename=GB-PE35-DS4.tar.bz2

QlpoOTFBWSZTWYHclvUACT1////0nMb8Z//4f/f/2v//3/RAxFCAAFASAQAAoAhCQMgI0AYPC6mq
RVUAoABgyVPIo0eo02kAyADQaAaDQ0AA0AD1D1AaA2oAaG1DgAAAAAAAMgAAAAAAAAADIACUyk0a
k9E1D0nqaeoaBoaANAAAAAABoADQAAA4AAAAAAADIAAAAAAAAAAyAAVJEjQEanqYaEZKeUzUep6j
R7SjTEyDyTQ0PU9Q0AaPUxNqA2UeoB3zkMCEKtUrTCeMRuPHhU8ZsB+GSGyHwjKhvoAgQQSRf83P
jkkUnNX1bJaSKyhHjqSHD8dizVZZUFqIqohpbbSEvUg706Z3+nprv5c61VScaRmky0zYLrrWtutj
MJFdDFbZSR3Im/vXRJl3O45WHoen4MWE0EpbOstxLL1et5IpUooEaAQQAULN7eTp7GDWmUYNSXJq
lKxHIoDrIpFFbq2KVkDx5TSy0UU6EWqCxQNWoLbVZ+NB/RQcoWJfURBl2t+oRgCawkIAS0IgVOZ6
pq1rWuY8KJAkUSUCHJN0HMkwSBtgtcYice9fDPHMIY3BEzIiDqHSPaF0rNsWEihP2ZytJOSkZOjK
HO4WWXiAQhFNSnMylNCxxz+bna6lVhjxzQ3C5M2buVdiIEIFgQhJKttJKRGC28SiCwOmIL5661Vj
Iz0PrOibalVKqVV01mw2bMJxKeJh0U7T2crBKqVVUpXxvANzmJSctIEBTWMsNUjamOYTKGFeJCWE
vF1X8Y7A2YBsoTKRchEZqgHDLJVSa2Z6UIu56kakSUsjtTmhg+lRI0qJHke/5HB+9+77+TkgeGZ5
aRokXmlaeOb/rVD0lJt218T7bNI1TVIp7c9y0NN5xS2DKqXkcBz5zC0vsKkWXIge5NWTnjOCeClg
6qlsjHuxbF0t4JqmK7FWjRohU9mVM00rZcmeZofXmMjblwViWEQoViSgrRBe78E4BqcCUA4rHE48
lNv6s+MPf8nA2z5H3XVGk77NCfC+ALPqYXWt3ri96qlmDaTGzMblqAJSSYEwlKbeaWnNuzLhEZB1
GtJPP1ZEupJ63eST9vvSJypJqwOo+U8rvJJ49R6PDr1/TkT4Umpi7E7bf+PyvVL8jiZ5E8q8cMiU
dUy4Kd0p8uOzvxNjNFzrRg1KYsZEss8qSXPM7f9JPsUtRLU/7tbHS0uw9yHppPmyQwC3cqqo8Ad+
bZHtL+M9SWl1KKiWWSWlpmeByqLP74SPCxGDEfIYMrKf2fBlJONI1Z11pJLNqRqH4k1vdkTKOyu0
1PdUwUpYUUGRI+5OKaVyTauu1vbgIGRDKDg4EYWNJKGxpJGhgBmdyaH2jvNyj3qWkT8CRsG5TdGx
Q4RyvE60iaExEaJmkicyKaUjSkXntPNBwBwRGWcxJSkjcrNJDU3ypJ4EihOykYQYwXGY83xdRtdR
ayTRBtHXF3qsjOaQ40jibHGLTK2Dov6/ztkiaR89RuSiyVCopSUVGlonBlgyTIyzhcylKVSuRvt3
adDm0TGJK4HniS0643kyGkqaVRysRgkLqkS2MOlS7qpp7CYI3pTW6xwSJcuDmjM5daRoGAzuCRMy
Za3/8dY0O3hI5Wqb+GDoShwxvCkjK5G8O6+ZI88jI1sU5DhbpE60h6n/v93SP693C1rciNsqI7Id
Dku1uvONtvIwN+JJ18JGG3Layy8iwUKjAoLxUzSTnXTczpTMummJM4ycJ6HikamRz64Rwt9hImdg
k3izLOfydSJIsb3CiUGw0XhZyQmsJkAz3/0P+weZoISOamf2VjrQgESHIav8XckU4UJCB3Jb1A==

--Boundary_(ID_oXkzemhCAfUZ2x5KqBZkgw)
Content-type: text/plain; charset=US-ASCII; format=flowed
Content-transfer-encoding: 7BIT




Roman Himmes
roman@himmes.com




--Boundary_(ID_oXkzemhCAfUZ2x5KqBZkgw)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--Boundary_(ID_oXkzemhCAfUZ2x5KqBZkgw)--
