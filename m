From: Khazhismel Kumykov <khazhy@google.com>
Subject: Re: [dm-devel] [PATCH] dm mpath selector: more evenly distribute ties
Date: Wed, 24 Jan 2018 10:44:11 -0800
Message-ID: <CACGdZYK5XBCjDgAyQ7+-teR24-G9fp1yuKqHawGLYd79BbGO=Q@mail.gmail.com>
References: <20180119230737.133596-1-khazhy@google.com> <1516791437.6678.6.camel@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="001a11c162bca7cfaf05638a0c95"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1516791437.6678.6.camel@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>
Cc: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--001a11c162bca7cfaf05638a0c95
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 24, 2018 at 2:57 AM, Martin Wilck <mwilck@suse.com> wrote:
> On Fri, 2018-01-19 at 15:07 -0800, Khazhismel Kumykov wrote:
>> Move the last used path to the end of the list (least preferred) so
>> that
>> ties are more evenly distributed.
>>
>> For example, in case with three paths with one that is slower than
>> others, the remaining two would be unevenly used if they tie. This is
>> due to the rotation not being a truely fair distribution.
>>
>> Illustrated: paths a, b, c, 'c' has 1 outstanding IO, a and b are
>> 'tied'
>> Three possible rotations:
>> (a, b, c) -> best path 'a'
>> (b, c, a) -> best path 'b'
>> (c, a, b) -> best path 'a'
>> (a, b, c) -> best path 'a'
>> (b, c, a) -> best path 'b'
>> (c, a, b) -> best path 'a'
>> ...
>
>
> This happens only if a and b actually have the same weight (e.g. queue
> length for the queue-length selector). If 'a' really receives more IO,
> its queue grows, and the selector will start preferring 'b', so the
> effect should level out automatically with the current code as soon as
> you have real IO going on. But maybe I haven't grasped what you're
> referring to as "tied".
Yes, for "tied" I'm referring to paths with the same weight. As queue
length grows it does tend to level out, but in the case where queue
length doesn't grow (in this example I'm imagining 2 concurrent
requests to the device) the bias does show and the selectors really do
send 'a' 2x more requests than 'b' (when 'c' is much slower and 'a'
and 'b' are ~same speed).

>
> OTOH, if the "best" path has much lower queue length than the other
> paths for whatever reason, your pushing it to the tail will require a
> full list walk with every new call of the selector. I see tjat as a
> small disadvantage of your approach.
I see, with best at the tail, we would not see as much benefit from
the check if a path has no IOs on it in queue-length. In service-time
no such short circuit exists, so I don't believe anything changes
there. Am I understanding this correctly?

>
> Regards
> Martin
>

Thanks for your comments,
Khazhy

>>
>> So 'a' is used 2x more than 'b', although they should be used evenly.
>>
>> With this change, the most recently used path is always the least
>> preferred, removing this bias resulting in even distribution.
>> (a, b, c) -> best path 'a'
>> (b, c, a) -> best path 'b'
>> (c, a, b) -> best path 'a'
>> (c, b, a) -> best path 'b'
>> ...
>>
>> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
>> ---
>>  drivers/md/dm-queue-length.c | 6 +++---
>>  drivers/md/dm-service-time.c | 6 +++---
>>  2 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/md/dm-queue-length.c b/drivers/md/dm-queue-
>> length.c
>> index 23f178641794..969c4f1a3633 100644
>> --- a/drivers/md/dm-queue-length.c
>> +++ b/drivers/md/dm-queue-length.c
>> @@ -195,9 +195,6 @@ static struct dm_path *ql_select_path(struct
>> path_selector *ps, size_t nr_bytes)
>>       if (list_empty(&s->valid_paths))
>>               goto out;
>>
>> -     /* Change preferred (first in list) path to evenly balance.
>> */
>> -     list_move_tail(s->valid_paths.next, &s->valid_paths);
>> -
>>       list_for_each_entry(pi, &s->valid_paths, list) {
>>               if (!best ||
>>                   (atomic_read(&pi->qlen) < atomic_read(&best-
>> >qlen)))
>> @@ -210,6 +207,9 @@ static struct dm_path *ql_select_path(struct
>> path_selector *ps, size_t nr_bytes)
>>       if (!best)
>>               goto out;
>>
>> +     /* Move most recently used to least preferred to evenly
>> balance. */
>> +     list_move_tail(&best->list, &s->valid_paths);
>> +
>>       ret =3D best->path;
>>  out:
>>       spin_unlock_irqrestore(&s->lock, flags);
>> diff --git a/drivers/md/dm-service-time.c b/drivers/md/dm-service-
>> time.c
>> index 7b8642045c55..f006a9005593 100644
>> --- a/drivers/md/dm-service-time.c
>> +++ b/drivers/md/dm-service-time.c
>> @@ -282,9 +282,6 @@ static struct dm_path *st_select_path(struct
>> path_selector *ps, size_t nr_bytes)
>>       if (list_empty(&s->valid_paths))
>>               goto out;
>>
>> -     /* Change preferred (first in list) path to evenly balance.
>> */
>> -     list_move_tail(s->valid_paths.next, &s->valid_paths);
>> -
>>       list_for_each_entry(pi, &s->valid_paths, list)
>>               if (!best || (st_compare_load(pi, best, nr_bytes) <
>> 0))
>>                       best =3D pi;
>> @@ -292,6 +289,9 @@ static struct dm_path *st_select_path(struct
>> path_selector *ps, size_t nr_bytes)
>>       if (!best)
>>               goto out;
>>
>> +     /* Move most recently used to least preferred to evenly
>> balance. */
>> +     list_move_tail(&best->list, &s->valid_paths);
>> +
>>       ret =3D best->path;
>>  out:
>>       spin_unlock_irqrestore(&s->lock, flags);
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>
> --
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=C3=BCrnberg)
>

--001a11c162bca7cfaf05638a0c95
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIS5wYJKoZIhvcNAQcCoIIS2DCCEtQCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ghBNMIIEXDCCA0SgAwIBAgIOSBtqDm4P/739RPqw/wcwDQYJKoZIhvcNAQELBQAwZDELMAkGA1UE
BhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExOjA4BgNVBAMTMUdsb2JhbFNpZ24gUGVy
c29uYWxTaWduIFBhcnRuZXJzIENBIC0gU0hBMjU2IC0gRzIwHhcNMTYwNjE1MDAwMDAwWhcNMjEw
NjE1MDAwMDAwWjBMMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEiMCAG
A1UEAxMZR2xvYmFsU2lnbiBIViBTL01JTUUgQ0EgMTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBALR23lKtjlZW/17kthzYcMHHKFgywfc4vLIjfq42NmMWbXkNUabIgS8KX4PnIFsTlD6F
GO2fqnsTygvYPFBSMX4OCFtJXoikP2CQlEvO7WooyE94tqmqD+w0YtyP2IB5j4KvOIeNv1Gbnnes
BIUWLFxs1ERvYDhmk+OrvW7Vd8ZfpRJj71Rb+QQsUpkyTySaqALXnyztTDp1L5d1bABJN/bJbEU3
Hf5FLrANmognIu+Npty6GrA6p3yKELzTsilOFmYNWg7L838NS2JbFOndl+ce89gM36CW7vyhszi6
6LqqzJL8MsmkP53GGhf11YMP9EkmawYouMDP/PwQYhIiUO0CAwEAAaOCASIwggEeMA4GA1UdDwEB
/wQEAwIBBjAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwEgYDVR0TAQH/BAgwBgEB/wIB
ADAdBgNVHQ4EFgQUyzgSsMeZwHiSjLMhleb0JmLA4D8wHwYDVR0jBBgwFoAUJiSSix/TRK+xsBtt
r+500ox4AAMwSwYDVR0fBEQwQjBAoD6gPIY6aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9ncy9n
c3BlcnNvbmFsc2lnbnB0bnJzc2hhMmcyLmNybDBMBgNVHSAERTBDMEEGCSsGAQQBoDIBKDA0MDIG
CCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzANBgkqhkiG
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
BQUHMAKGNGh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzaHZzbWltZWNhMS5j
cnQwHQYDVR0OBBYEFMnO7tLwRUm/Kh/G63DTEdz9N5wmMB8GA1UdIwQYMBaAFMs4ErDHmcB4koyz
IZXm9CZiwOA/MEwGA1UdIARFMEMwQQYJKwYBBAGgMgEoMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8v
d3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMDsGA1UdHwQ0MDIwMKAuoCyGKmh0dHA6Ly9j
cmwuZ2xvYmFsc2lnbi5jb20vZ3NodnNtaW1lY2ExLmNybDAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMA0GCSqGSIb3DQEBCwUAA4IBAQA5gzhiP9g5DzgYyM4K
/OtFFFKyrluiKx9OmOb1Mx9UCxEi9vzRrG5j1rFMAwNAx+xEESoq1JVNe8fJKBimOsKpWstAhYlO
Cg6Qm43dzb+5CcPWDC3j6XxfsUIKvektE79/IeVhdRVj+Op1gSEGaBJQP2c0/MeXPPhQKPjAPVQW
bEOJaemCXr1UIoEHMoisd0Smdm1NjxLYLk3bK1RDgO0RTu2hNmVAT9WypS9uiquOQWeK3u9QBuUK
BhOZjgo70YosoRVRBIKNqStZ++IpaDEWfDme3EH4H8tlOzwCvAiO8c1uF7ZX68wXWJPjq6uxu1cZ
5lT83BZ34AElNAzFvsLhMYICXjCCAloCAQEwXDBMMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xv
YmFsU2lnbiBudi1zYTEiMCAGA1UEAxMZR2xvYmFsU2lnbiBIViBTL01JTUUgQ0EgMQIMPycjokgk
Gdp8HTY2MA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCDVK3bGrkYArw3kNFu6aqRZ
zL1qGacTKFOb+02kTYkgqzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEP
Fw0xODAxMjQxODQ0MTJaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQB
FjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzALBglg
hkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAjW8Bsq2pgaBVh+rBC87Jd3HOUzg/PYgr5emEk1GQ
15HbyhL2+YbXEMOt4Rk3bI7DKDJPh8Wa0QgvCZnVr8z7d7SV7Bapr8vjP3YEm5yWHl/rS7Dk8z7x
e1WQa+31TT05OXl/NQKlyMyIQBSSJ+lc8s6ggLAwvdSnw7Y81nXTXzxOiSnNwNIwFSUn7apbZS+e
df45Wxz0C9cenAIHXBNAblpJbCB0PVC2wRJi0aCTMy1wkL815GU4uAZKcOH5D+67cYQAljM1FN5c
OzJ4A7PykIFmMWOtupjIKmEH/X3DRCBT2FOz1+Bo/ZD50zYlWYz2c9bcSgVayUiwNSDYqARmOw==
--001a11c162bca7cfaf05638a0c95--
